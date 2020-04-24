require 'gosu'
require 'chipmunk'
require_relative 'components/constants'
require_relative 'components/zorder'
require_relative 'components/cursor'
require_relative 'components/ship'

class Game < Gosu::Window
  def initialize
    super(Constants::WindowWidth, Constants::WindowHeight, false)

    self.caption = Constants::AppName

    # Fixed dt to improve chipmunk performance
    @dt = 1.0 / 60.0

    @background = Gosu::Image.new('src/assets/images/background.png')

    @cursor = Cursor.new(self)

    @space = CP::Space.new
    @space.damping = 0.8

    @ship = Ship.new(self, @space, {
      :mass => 10.0,
      :inertia => 15.0,
      :shoot_interval => 300
    })

    @ship.shape.body.p = CP::Vec2.new(Constants::WindowWidth / 2.0, Constants::WindowHeight / 2.0)
  end

  def update
    update_cursor
    @ship.update
    @space.step(@dt)
  end

  def draw
    @background.draw(0, 0, ZOrder::Background, Constants::WindowWidth.to_f / @background.width, Constants::WindowHeight.to_f / @background.height)
    @cursor.draw
    @ship.draw
  end

  def update_cursor
    if button_down?(Gosu::MS_LEFT)
      @cursor.state = CursorState::Active
    else
      @cursor.state = CursorState::Normal
    end
  end
end
