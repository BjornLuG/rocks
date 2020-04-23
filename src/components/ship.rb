require 'gosu'
require 'chipmunk'
require_relative 'sprite'
require_relative 'zorder'
require_relative 'constants'

class Ship < Sprite
  def initialize(window, space, specs)
    img = Gosu::Image.new('src/assets/images/ship.png')
    radius = [img.width, img.height].max / 2.0
    body = CP::Body.new(specs[:mass], specs[:inertia])
    @shape = CP::Shape::Circle.new(body, radius, CP::Vec2::ZERO)

    super(img, @shape, ZOrder::Ship)

    space.add_body(body)
    space.add_shape(shape)

    @specs = specs
    @window = window

    # Cache last shoot time to calculate shoot interval
    @lastShootMs = Gosu::milliseconds()
  end

  def update
    relative_x = @window.mouse_x - @shape.body.p.x
    relative_y = @window.mouse_y - @shape.body.p.y

    @shape.body.a = Math.atan2(relative_y, relative_x)

    if @window.button_down?(Gosu::MS_LEFT) && can_shoot
      @shape.body.apply_impulse(CP::Vec2.new(relative_x, relative_y).normalize_safe * -100.0, CP::Vec2::ZERO)
    end

    validate_move_area
  end

  private

  def can_shoot
    if Gosu::milliseconds() - @lastShootMs > @specs[:shoot_interval]
      @lastShootMs = Gosu::milliseconds()
      return true
    else
      return false
    end
  end

  def validate_move_area
    @shape.body.p.x = @shape.body.p.x.clamp(Constants::WindowPadding, @window.width - Constants::WindowPadding)
    @shape.body.p.y = @shape.body.p.y.clamp(Constants::WindowPadding, @window.height - Constants::WindowPadding)
  end
end
