--preserve: Pen
if (Pen == nil) Pen = {data = {}}

local function _add_token_to_plane(plane, p, x1, x2)
  if #plane > 1 and plane[#plane].x1 == x1 - 1 and plane[#plane].p == p then
    plane[#plane].x2 = x2 -- extend previous token
  else
    add(plane, {p = p, x1 = x1, x2 = x2})
  end
end

local function _add_token(row_data, p, x1, x2, vcol)
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

-- fill patterns for each plane
local fill_patterns = {
  0b0000000000000000,
  0b0101101001011010,
  0b0001010000010100,
}

-- fill patterns for opacity (0..16, 16 == opaque)
local opacity_patterns = {
  0b1111111111111111.1,

  0b1111111111111011.1,
  0b1111011111111101.1,
  0b1111111011111010.1,
  0b1111010111110101.1,
  0b1111101001111010.1,
  0b1110010111100101.1,
  0b0111101001011010.1,
  0b1010010110100101.1,

  0b0101101001001010.1,
  0b1010010100000101.1,
  0b0001101000001010.1,
  0b0000010100000101.1,
  0b0000101000000010.1,
  0b0000010000000100.1,
  0b0000001000000000.1,
  0b0000000000000000.1,
}

local function _draw_plane(matrix, plane_index, x, y, dx1, dy1, dx2, dy2, opacity)
  if opacity == nil or opacity >= 16 then
    fillp(fill_patterns[plane_index])
  else
    fillp(opacity_patterns[max(flr(opacity), 0) + 1])
  end

  for y1 = dy1, dy2 do
    local row_data = matrix[y1 + 1]
    for token in all(row_data[plane_index]) do
      -- should skip if (token.x2 < dx1 or token.x1 > dx2), but the comparison is way too slow :(
      rectfill(x + token.x1, y + y1, x + token.x2, y + y1, token.p)
    end
  end
  fillp(0)
end

local screen_w, screen_h = 127, 127

-- convert a string into image data and cache it
Pen.decode = function (name)
  if (type(Pen.data[name]) != 'string') return

  local data = split(Pen.data[name], '\n', false)

  -- split headers and data
  local headers = {}
  while data[1] != '---' do
    add(headers, deli(data, 1))
  end
  deli(data, 1)

  -- display palette
  local dpal = {}
  local dpal_header = headers[1]
  for p = 2, #dpal_header do
    add(dpal, ord(dpal_header, p) - 0x30)
  end
  add(dpal, ord(dpal_header, 1) - 0x30)

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
    add(tokens, {len = t1 - 0x30, p = t2 - 0x30})
  end

  local w = nil
  local matrix = {}
  for row in all(data) do
    if (row == '') then
      -- transparent row
      add(matrix, {})
    elseif (sub(row, 1, 1) == '*') then
      -- ditto rows
      for _ = 1, tonum(sub(row, 2)) do
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
          _add_token(row_data, token.p, x, x + token.len - 1, vcol)
          x += token.len
          i += 1
        else
          -- len == run length
          local p = ord(row, i + 1) - 0x30
          _add_token(row_data, p, x, x + len - 1, vcol)
          x += len
          i += 2
        end
      end
      add(matrix, row_data)
      w = w or x
    end
  end

  -- ready to draw
  Pen.data[name] = {
    name = name,
    w = w,
    h = #matrix,
    dpal = dpal,
    vcol = vcol,
    matrix = matrix,
  }
  return Pen.data[name]
end

Pen.init = function ()
  for name, _ in pairs(Pen.data) do
    Pen.decode(name)
  end
end

Pen.get = function (img_or_name)
  if type(img_or_name) == 'table' then
    return img_or_name
  else
    local img = Pen.data[img_or_name]
    if (type(img) == 'string') img = Pen.decode(img_or_name)
    if (img == nil) stop('image not found: ' .. tostr(img_or_name))
    return img
  end
end

-- crop src img and create a new img object
Pen.crop = function (img_or_name, cx1, cy1, cx2, cy2)
  local img = Pen.get(img_or_name)

  local matrix = {}
  for y1 = cy1, cy2 do
    local row_data = {}
    for plane_index = 1, 3 do
      local plane = {}
      for token in all(img.matrix[y1 + 1][plane_index]) do
        if token.x2 >= cx1 and token.x1 <= cx2 then
          add(plane, {x1 = max(token.x1, cx1) - cx1,
            x2 = min(token.x2, cx2) - cx1, p = token.p})
        end
      end
      add(row_data, plane)
    end
    add(matrix, row_data)
  end

  return {
    name = img.name .. ' (cropped)',
    w = cx2 - cx1 + 1,
    h = #matrix,
    dpal = img.dpal,
    vcol = img.vcol,
    matrix = matrix,
  }
end

Pen.draw = function (img_or_name, ...)
  local img = Pen.get(img_or_name)
  local args = {...}

  -- camera coords
  local camera_x, camera_y = peek2(0x5f28), peek2(0x5f2a)

  -- display coords
  local x, y = flr(args[1] or 0), flr(args[2] or 0)

  -- clipping region (from top-left corner of the image)
  local clip_coords = args[3] or {}
  local cx1, cy1 = flr(clip_coords[1] or 0), flr(clip_coords[2] or 0)
  local cx2, cy2 = flr(clip_coords[3] or img.w - 1), flr(clip_coords[4] or img.h - 1)
  cx2, cy2 = min(cx2, img.w - 1), min(cy2, img.h - 1)

  -- opacity (0..16, 16 == opaque)
  local opacity = args[4] or 16

  -- shifted coords
  local shifted_x, shifted_y = (x - cx1), (y - cy1)

  -- display region in the whole image
  local dx1 = max(cx1, camera_x - shifted_x)
  local dy1 = max(cy1, camera_y - shifted_y)
  local dx2 = min(cx2, camera_x + screen_w - shifted_x)
  local dy2 = min(cy2, camera_y + screen_h - shifted_y)
  if (dx1 >= dx2 or dy1 >= dy2) return

  -- set display palette
  pal(img.dpal, 1);

  -- override _draw_plane() function
  local draw_plane_func = args[5] or _draw_plane

  clip(x - camera_x, y - camera_y, cx2 - cx1 + 1, cy2 - cy1 + 1)
  for plane_index = 1, 3 do
    draw_plane_func(img.matrix, plane_index, shifted_x, shifted_y, dx1, dy1, dx2, dy2, opacity)
  end
  clip(0) -- TODO: restore the original clip region
end
