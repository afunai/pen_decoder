pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- my own image format
-- by afunai

function _init()
  --[[
    defines "Pen.draw" and other functions:
      Pen.draw(
        image_name | image object,
        [x, y],
        [{cx1, cy1, cx2, cy2}],
        [opacity],
        [draw_plane_func()]
      }
  --]]
  #include pen_decoder.lua

  --[[
    defines "Pen.data":
      each image is
        an encoded string value
        in the table.
  --]]
  #include pen_data.lua

  --[[
    decode string values
      in Pen.data
      and cache them.
  ]]
  Pen.init()
end

function _draw()
  cls()
  Pen.draw('icon')
end
