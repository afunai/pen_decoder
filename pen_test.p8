pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- my own image format
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
end

function _draw()
  cls()
  draw_img('icon')
end
