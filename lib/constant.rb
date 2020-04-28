# frozen_string_literal: true

module Constant
  APP_NAME = 'Rocks'
  WINDOW_WIDTH = 700
  WINDOW_HEIGHT = 500
  WINDOW_PADDING = 50
  FONT_NAME = 'lib/assets/fonts/kenvector_future.ttf'
  FONT_SM = Gosu::Font.new(24, { name: FONT_NAME })
  FONT_MD = Gosu::Font.new(56, { name: FONT_NAME })
  FONT_LG = Gosu::Font.new(80, { name: FONT_NAME })
  FONT_XL = Gosu::Font.new(120, { name: FONT_NAME })
end
