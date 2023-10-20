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

-- shade patterns for transition
shades = {
  0b1111111110111111,
  0b1111111110011111,
  0b1111110110011111,
  0b1111100110011111,
  0b1111000110011111,
  0b1111000100011111,
  0b1111000100010111,
  0b1111000100010011,

  0b1111000100010001,
  0b1111000100010000,
  0b1111000100000000,
  0b1111000000000000,
  0b1110000000000000,
  0b1100000000000000,
  0b1000000000000000,
  0b0000000000000000,
}

-- transition variations
-- frame  1-16: fadeout
-- frame 17-32: fadein
transitions = {
  -- slide
  function(frame)
    if frame <= 16 then
      draw_img(img_names[i], frame * vi * 8, 0)
    else
      draw_img(img_names[i], (frame - 17) * vi * 8 + (-128 * vi), 0)
    end
  end,

  -- dissolve
  function(frame)
    draw_img(img_names[i])
    print(frame,100,3)
    if frame <= 16 then
      fillp(shades[frame] + 0b.1)
    else
      fillp(shades[33 - frame] + 0b.1)
    end
    rectfill(0, 0, 127, 127, 0)
  end,
}

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
    ['transition_type'] = 2,
    ['update'] = function()
      local this = modes.transition
      if this.frame == 0 then
        -- start transition
        this.transition_type = 2
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
      if (this.frame > 0) transitions[this.transition_type](this.frame)
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
