require 'gosu'
require_relative 'constants'
require_relative 'zorder'
require_relative 'cursor'

class Game < Gosu::Window
  def initialize
    super(Constants::WindowWidth, Constants::WindowHeight, false)

    self.caption = Constants::AppName

    @background = Gosu::Image.new('src/assets/images/background.png')

    @cursor = Cursor.new(
      self,
      Gosu::Image.new('src/assets/images/cursor/normal.png'),
      Gosu::Image.new('src/assets/images/cursor/active.png'),
      Gosu::Image.new('src/assets/images/cursor/active.png'),
    )
  end

  def draw
    @background.draw(0, 0, ZOrder::Background, Constants::WindowWidth.to_f / @background.width, Constants::WindowHeight.to_f / @background.height)
    @cursor.draw
  end
end
