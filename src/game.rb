# frozen_string_literal: true

require 'gosu'
require 'chipmunk'
require_relative 'components/constants'
require_relative 'components/zorder'
require_relative 'components/cursor'
require_relative 'components/ship'

# The main game class
class Game < Gosu::Window
  def initialize
    super(Constants::WINDOW_WIDTH, Constants::WINDOW_HEIGHT, false)

    self.caption = Constants::APP_NAME

    # Fixed dt to improve chipmunk performance
    @dt = 1.0 / 60.0

    @background = Gosu::Image.new('src/assets/images/background.png')

    @cursor = Cursor.new(self)

    @space = CP::Space.new
    @space.damping = 0.8

    @ship = Ship.new(
      self,
      @space,
      {
        mass: 10.0,
        inertia: 15.0,
        shoot_interval: 300
      }
    )

    @ship.shape.body.p = CP::Vec2.new(
      Constants::WINDOW_WIDTH / 2.0,
      Constants::WINDOW_HEIGHT / 2.0
    )
  end

  def update
    update_cursor
    @ship.update
    @space.step(@dt)
  end

  def draw
    draw_background
    @cursor.draw
    @ship.draw
  end

  private

  def draw_background
    @background.draw(
      0,
      0,
      ZOrder::BACKGROUND,
      Constants::WINDOW_WIDTH.to_f / @background.width,
      Constants::WINDOW_HEIGHT.to_f / @background.height
    )
  end

  def update_cursor
    @cursor.state = if button_down?(Gosu::MS_LEFT)
                      CursorState::ACTIVE
                    else
                      CursorState::NORMAL
                    end
  end
end
