pen_data = {}

function init_img()
  for name, str in pairs(pen_data) do
    local data = split(str, '\n', false)

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
        while (i < #row) do
          local len = ord(row, i) - 0x30
          if (len < 0) then
            -- orphan pixels
            for j = i + 1, i - len do
              local p = ord(row, j) - 0x30
              if (p != 63) add(row_data, {['p'] = p, ['x1'] = x, ['x2'] = x})
              x += 1
            end
            i += 1 - len
          else
            local p = ord(row, i + 1) - 0x30
            if (p != 63) add(row_data, {['p'] = p, ['x1'] = x, ['x2'] = x + len - 1})
            x += len
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
  end
end

screen_w, screen_h = 127, 127

function draw_img(name, x, y, ...)
  local img = pen_data[name]
  assert(img != nil, 'image not found: ' .. name)

  local img_w, img_h = img.w - 1, img.h - 1

  local camera_x = peek2(0x5f28)
  local camera_y = peek2(0x5f2a)

  args = {...}
  -- clipping coords (begins from 0)
  local cx1 = max(args[1] or 0, min(camera_x, 0) - x)
  local cy1 = max(args[2] or 0, min(camera_y, 0) - y)
  local cx2 = min(args[3] or img_w, camera_x + screen_w - x)
  local cy2 = min(args[4] or img_h, camera_y + screen_h - y)
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
        if (img.vcol[row.p - 15] > 0xff) then
          fillp(0b1110101111101011)
        else
          fillp(0b1010010110100101)
        end
        rectfill(max(x + cx1, x + row.x1), y + y1, min(x + cx2, x + row.x2), y + y1, img.vcol[row.p - 15])
        fillp(0)
      end
    end
  end
end
