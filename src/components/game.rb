require 'gosu'
require 'chipmunk'
require_relative 'constants'
require_relative 'zorder'
require_relative 'cursor'
require_relative 'ship'

class Game < Gosu::Window
  def initialize
    super(Constants::WindowWidth, Constants::WindowHeight, false)

    self.caption = Constants::AppName

    # Fixed dt to improve chipmunk performance
    @dt = 1.0 / 60.0

    @background = Gosu::Image.new('src/assets/images/background.png')

    @cursor = Cursor.new(
      self,
      Gosu::Image.new('src/assets/images/cursor/normal.png'),
      Gosu::Image.new('src/assets/images/cursor/active.png'),
      Gosu::Image.new('src/assets/images/cursor/active.png'),
    )

    @space = CP::Space.new
    @space.damping = 0.8

    @ship = Ship.new(@space)
    @ship.shape.body.p = CP::Vec2.new(Constants::WindowWidth / 2.0, Constants::WindowHeight / 2.0)
  end

  def update
    @space.step(@dt)
  end

  def draw
    @background.draw(0, 0, ZOrder::Background, Constants::WindowWidth.to_f / @background.width, Constants::WindowHeight.to_f / @background.height)
    @cursor.draw
    @ship.draw
  end
end
