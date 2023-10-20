pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- tiny slideshow w/ "pen" format
-- by afunai

function _init()
  --[[
    defines "draw_img":
      draw_img(
        image_name,
        [x, y],
        [cx1, cy1, cx2, cy2]
      }
  --]]
  #include pen_decoder.lua

  --[[
    defines "pen_data":
      each image is
        an encoded string value
        in the table.
  --]]
  #include pen_data.lua

  --[[
    decode string values
      in pen_data
      and cache them.
  ]]
  init_img()

  -- get all image names for slideshow
  img_names = {}
  for name, data in pairs(pen_data) do
    add(img_names, name)
  end
end

-- image index
i = 1

function _update()
  if (btnp(0)) i -= 1
  if (btnp(1)) i += 1
  if (i < 1) i = #img_names
  if (i > #img_names) i = 1
end

-- image properties
function print_properties(img_name)
  local img = pen_data[img_name]
  print('name:'..img.name, 77, 3, 0)
  print(' dim:'..img.w..'X'..img.h)
end

function _draw()
  cls()

  draw_img(img_names[i])

  print_properties(img_names[i])
  print('press ⬅️➡️')
end
