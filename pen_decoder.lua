pen_data = {}

function _add_token_to_plane(plane, p, x1, x2)
  if #plane > 1 and plane[#plane].x1 == x1 - 1 and plane[#plane].p == p then
    plane[#plane].x2 = x2 -- extend previous token
  else
    add(plane, {['p'] = p, ['x1'] = x1, ['x2'] = x2})
  end
end

function _add_token(row_data, p, x1, x2, vcol)
  if p < 16 then
    _add_token_to_plane(row_data[1], p, x1, x2)
  elseif p == 16 then
    -- skip transparent tokens
  elseif vcol[p - 16] <= 0xff then
    _add_token_to_plane(row_data[2], vcol[p - 16], x1, x2)
  else
    _add_token_to_plane(row_data[3], vcol[p - 16], x1, x2)
  end
end

-- convert a string into image data and cache it
function decode_img(name)
  if (type(pen_data[name]) != 'string') return

  local data = split(pen_data[name], '\n', false)

  -- split headers and data
  local headers = {}
  while data[1] != '---' do
    add(headers, deli(data, 1))
  end
  deli(data, 1)

  -- display palette
  local dpal = {}
  local dpal_header = headers[1]
  for p = 1, #dpal_header do
    add(dpal, ord(dpal_header, p) - 0x30)
  end

  -- virtual colors
  local vcol = {}
  local vcol_header = headers[2]
  for i = 1, #vcol_header, 2 do
    local c1, c2 = ord(vcol_header, i, 2)
    add(vcol, (c1 - 0x30) * 16 + (c2 - 0x30))
  end

  -- indexed tokens
  local tokens = {}
  local tokens_header = headers[3]
  for i = 1, #tokens_header, 2 do
    local t1, t2 = ord(tokens_header, i, 2)
    add(tokens, {['len'] = t1 - 0x30, ['p'] = t2 - 0x30})
  end

  local w = nil
  local matrix = {}
  for row in all(data) do
    if (sub(row, 1, 1) == '*') then
      -- ditto rows
      for i = 1, tonum(sub(row, 2)) do
        add(matrix, matrix[#matrix])
      end
    else
      local x = 0
      local i = 1
      local row_data = {{}, {}, {}} -- 3 planes for each color type
      while (i <= #row) do
        local len = ord(row, i) - 0x30
        if (len >= 128) then
          -- len == pixel color index
          local p = len - 128
          _add_token(row_data, p, x, x, vcol)
          x += 1
          i += 1
        elseif (len >= 64) then
          -- len == token index
          local token = tokens[len - 64 + 1]
          _add_token(row_data, token.p, x, x + token.len, vcol)
          x += token.len + 1
          i += 1
        else
          -- len == run length
          local p = ord(row, i + 1) - 0x30
          _add_token(row_data, p, x, x + len, vcol)
          x += len + 1
          i += 2
        end
      end
      add(matrix, row_data)
      w = w or x
    end
  end

  -- ready to draw
  pen_data[name] = {
    ['name'] = name,
    ['w'] = w,
    ['h'] = #matrix,
    ['dpal'] = dpal,
    ['vcol'] = vcol,
    ['matrix'] = matrix,
  }
  return pen_data[name]
end

-- fill patterns for each plane
fill_patterns = {
  0b0000000000000000,
  0b1010010110100101,
  0b1110101111101011,
}

function _draw_plane(matrix, plane_index, x, y, cx1, cy1, cx2, cy2)
  fillp(fill_patterns[plane_index])
  for y1 = cy1, cy2 do
    local row_data = matrix[y1 + 1]
    for token in all(row_data[plane_index]) do
      -- should skip if (token.x2 < cx1 or token.x1 > cx2), but the comparison is way too slow :(
      rectfill(x + token.x1, y + y1, x + token.x2, y + y1, token.p)
    end
  end
  fillp(0)
end

screen_w, screen_h = 127, 127

function draw_img(name, ...)
  local img = pen_data[name]
  if (type(img) == 'string') img = decode_img(name)
  assert(img != nil, 'image not found: ' .. name)

  args = {...}
  local x = (args[1] or 0) - (args[3] or 0) -- shift coord according to cx1
  local y = (args[2] or 0) - (args[4] or 0) -- same for y

  local img_w, img_h = img.w - 1, img.h - 1

  local camera_x = peek2(0x5f28)
  local camera_y = peek2(0x5f2a)

  -- clipping coords (begins from 0)
  local cx1 = max(args[3] or 0, min(camera_x, 0) - x)
  local cy1 = max(args[4] or 0, min(camera_y, 0) - y)
  local cx2 = min(args[5] or img_w, camera_x + screen_w - x)
  local cy2 = min(args[6] or img_h, camera_y + screen_h - y)
  if (cx1 >= cx2 or cy1 >= cy2) return

  -- set display palette
  for p = 1, #img.dpal do
    pal(p - 1, img.dpal[p], 1);
  end

  clip((args[1] or 0) - camera_x, (args[2] or 0) - camera_y, cx2 - cx1 + 1, cy2 - cy1 + 1)
  for plane_index = 1, 3 do
    _draw_plane(img.matrix, plane_index, x, y, cx1, cy1, cx2, cy2)
  end
end
