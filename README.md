# Image decoder for PICO-8

## How to Use

1. Copy `pen_decoder.min.lua` and `pen_data.lua` into your cart folder.
2. Encode your own image(s) and paste them into `pen_data.lua`. You can use the encoder (a JavaScript app that works without a server) available at:  <https://github.com/afunai/pen_encoder>
3. In YOUR_CART.p8:

```lua
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
  #include pen_decoder.min.lua

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

```

Enjoy!

