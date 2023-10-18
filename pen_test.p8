pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- my own image format
-- by afunai

function _init()
 #include pen_decoder.lua
 #include pen_data.lua
end

function _draw()
 cls()
 draw_img('test')
end

