pen_data = {}

function _add_line(row_data, p, x1, x2)
  if p != 16 then
    if #row_data > 1 and row_data[#row_data].p == p then
      row_data[#row_data].x2 = x2 -- extend previous line
    else
      add(row_data, {['p'] = p, ['x1'] = x1, ['x2'] = x2})
    end
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
      local row_data = {}
      while (i <= #row) do
        local len = ord(row, i) - 0x30
        if (len >= 128) then
          -- len == pixel color index
          local p = len - 128
          _add_line(row_data, p, x, x)
          x += 1
          i += 1
        elseif (len >= 64) then
          -- len == token index
          local token = tokens[len - 64 + 1]
          _add_line(row_data, token.p, x, x + token.len)
          x += token.len + 1
          i += 1
        else
          -- len == run length
          local p = ord(row, i + 1) - 0x30
          _add_line(row_data, p, x, x + len)
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

screen_w, screen_h = 127, 127

function draw_img(name, ...)
  local img = pen_data[name]
  if (type(img) == 'string') img = decode_img(name)
  assert(img != nil, 'image not found: ' .. name)

  args = {...}
  local x = args[1] or 0
  local y = args[2] or 0

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

  for y1 = cy1, cy2 do
    local row_data = img.matrix[y1 + 1]
    for row in all(row_data) do
      if (row.x2 < cx1 or row.x1 > cx2) then
        -- out of clipping area
      elseif (row.p < 16) then
        rectfill(max(x + cx1, x + row.x1), y + y1, min(x + cx2, x + row.x2), y + y1, row.p)
      else
        if (img.vcol[row.p - 16] > 0xff) then
          fillp(0b1110101111101011)
        else
          fillp(0b1010010110100101)
        end
        rectfill(max(x + cx1, x + row.x1), y + y1, min(x + cx2, x + row.x2), y + y1, img.vcol[row.p - 16])
        fillp(0)
      end
    end
  end
end
