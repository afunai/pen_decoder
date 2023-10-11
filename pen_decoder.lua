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

    -- draw pallete
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

    -- ready to draw
    pen_data[i] = {
      ['dpal'] = dpal,
      ['vcol'] = vcol,
      ['data'] = data,
    }
  end
end

function draw_img(name)
  local img = pen_data[name]

  for p = 1, #img.dpal do
    pal(p - 1, img.dpal[p], 1);
  end

  for y, line in pairs(img.data) do
    local x = 0
    for i = 1, #line, 2 do
      local p, len = ord(line, i, 2)
      p -= 0x30
      len -= 0x30
      if (p < 16) then
        rectfill(x, y, x + len, y, p)
      else
        fillp(0b1010010110100101)
        rectfill(x, y, x + len, y, img.vcol[p - 15])
        fillp(0)
      end
      x += len
    end
  end
end
