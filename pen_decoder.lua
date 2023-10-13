pen_data = {}

function init_img()
  for i, str in pairs(pen_data) do
    local data = split(str, '\n', false)

    -- split headers and data
    local headers = {}
    while data[1] != '---' do
      add(headers, data[1])
      deli(data, 1)
    end
    deli(data, 1)

    -- draw palette
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
              if (p != 63) add(row_data, {['p'] = p, ['x1'] = x, ['x2'] = x + 1})
              x += 1
            end
            i += 1 - len
          else
            local p = ord(row, i + 1) - 0x30
            if (p != 63) add(row_data, {['p'] = p, ['x1'] = x, ['x2'] = x + len})
            x += len
            i += 2
          end
        end
        add(matrix, row_data)
      end
    end

    -- ready to draw
    pen_data[i] = {
      ['dpal'] = dpal,
      ['vcol'] = vcol,
      ['matrix'] = matrix,
    }
  end
end

function draw_img(name, x, y, ...)
  local img = pen_data[name]

  args = {...}
  -- clipping coords (begins from 0)
  local cx1 = max(0, max(args[1], -x))
  local cy1 = max(0, max(args[2], -y))
  local cx2 = min(args[3] or 127, 127 - x)
  local cy2 = min(#img.matrix - 1, min(args[4] or 127, 127 - y))
  print(cx1..','..cy1..'-'..cx2..','..cy2,2,2)

  for p = 1, #img.dpal do
    pal(p - 1, img.dpal[p], 1);
  end

  for y1 = cy1, cy2 do
    local row_data = img.matrix[y1 + 1]
    for row in all(row_data) do
      if (row.p < 16) then
        rectfill(x + row.x1, y + y1, x + row.x2, y + y1, row.p)
      else
        if (img.vcol[row.p - 15] > 0xff) then
          fillp(0b1110101111101011)
        else
          fillp(0b1010010110100101)
        end
        rectfill(x + row.x1, y + y1, x + row.x2, y + y1, img.vcol[row.p - 15])
        fillp(0)
      end
    end
  end
end
