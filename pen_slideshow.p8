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

-- print image properties
function print_properties(img_name)
  local img = pen_data[img_name]
  print('name:'..img.name, 77, 3, 0)
  print(' dim:'..img.w..'X'..img.h)
end

-- image index
i = 1

-- transition vector
vi = 0

-- modes
modes = {
  ['waiting'] = {
    ['update'] = function()
      if (btnp(0)) mode = 'transition' vi = -1
      if (btnp(1)) mode = 'transition' vi = 1
    end,
    ['draw'] = function()
      cls()
      draw_img(img_names[i])

      print_properties(img_names[i])
      print('press ⬅️➡️')
    end,
  },

  ['transition'] = {
    ['frame'] = 0,
    ['update'] = function()
      local this = modes.transition
      if this.frame == 0 then
        -- start transition
        this.frame = 1
      elseif this.frame < 16 then
        -- fade out
        this.frame += 1
      elseif this.frame == 16 then
        -- switch images
        i += vi
        if (i < 1) i = #img_names
        if (i > #img_names) i = 1
        this.frame += 1
      elseif this.frame < 32 then
        -- fade in
        this.frame += 1
      else
        -- end transition
        this.frame = 0
        mode = 'waiting'
      end
    end,
    ['draw'] = function()
      local this = modes.transition
      cls()
      if this.frame <= 16 then
        draw_img(img_names[i], this.frame * vi * 8, 0)
      else
        draw_img(img_names[i], (this.frame - 17) * vi * 8 + (-128 * vi), 0)
      end
    end,
  },
}

mode = 'waiting'

function _update60()
  modes[mode].update()
end

function _draw()
  modes[mode].draw()
end
