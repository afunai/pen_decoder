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
    for y, row in pairs(data) do
      local x = 0
      local row_data = {}
      for i = 1, #row, 2 do
        local len, p = ord(row, i, 2)
        add(row_data, {['p'] = p - 0x30, ['x1'] = x, ['x2'] = x + len - 0x30})
        x += len - 0x30
      end
      add(matrix, row_data)
    end

    -- ready to draw
    pen_data[i] = {
      ['dpal'] = dpal,
      ['vcol'] = vcol,
      ['matrix'] = matrix,
    }
  end
end

function draw_img(name)
  local img = pen_data[name]

  for p = 1, #img.dpal do
    pal(p - 1, img.dpal[p], 1);
  end

  for y, row_data in pairs(img.matrix) do
    for row in all(row_data) do
      if (row.p < 16) then
        rectfill(row.x1, y, row.x2, y, row.p)
      else
        fillp(0b1010010110100101)
        rectfill(row.x1, y, row.x2, y, img.vcol[row.p - 15])
        fillp(0)
      end
    end
  end
end
