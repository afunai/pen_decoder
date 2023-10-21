# Image decoder for PICO-8

## How to Use

1. Copy `pen_decoder.lua` and `pen_data.lua` into your cart folder.
2. Encode your own image(s) and paste them into `pen_data.lua`. You can use the encoder (a JavaScript app that works without a server) available at:  <https://github.com/afunai/pen_encoder>
3. In YOUR_CART.p8:

```lua
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
end

function _draw()
  cls()
  draw_img('YOUR_IMAGE_NAME')
end

```

Enjoy!

