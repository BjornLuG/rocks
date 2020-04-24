# frozen_string_literal: true

require_relative 'sprite'

# The player ship
class Ship < Sprite
  def initialize(window, space, specs)
    img = Gosu::Image.new('lib/assets/images/ship.png')
    radius = [img.width, img.height].max / 2.0
    body = CP::Body.new(specs[:mass], specs[:inertia])
    @shape = CP::Shape::Circle.new(body, radius, CP::Vec2::ZERO)

    super(img, @shape, ZOrder::SHIP)

    space.add_body(body)
    space.add_shape(shape)

    @specs = specs
    @window = window

    # Cache last shoot time to calculate shoot interval
    @last_shoot_ms = Gosu.milliseconds
  end

  def update
    update_position
    update_rotation
    shoot if @window.button_down?(Gosu::MS_LEFT) && can_shoot
  end

  private

  def can_shoot
    if Gosu.milliseconds - @last_shoot_ms > @specs[:shoot_interval]
      @last_shoot_ms = Gosu.milliseconds
      true
    else
      false
    end
  end

  def update_position
    @shape.body.p.x = @shape.body.p.x.clamp(
      Constants::WINDOW_PADDING,
      @window.width - Constants::WINDOW_PADDING
    )

    @shape.body.p.y = @shape.body.p.y.clamp(
      Constants::WINDOW_PADDING,
      @window.height - Constants::WINDOW_PADDING
    )
  end

  def update_rotation
    @shape.body.a = Math.atan2(
      @window.mouse_y - @shape.body.p.y,
      @window.mouse_x - @shape.body.p.x
    )
  end

  def shoot
    impulse = CP::Vec2.new(
      @window.mouse_x - @shape.body.p.x,
      @window.mouse_y - @shape.body.p.y
    ).normalize_safe * -100.0

    @shape.body.apply_impulse(impulse, CP::Vec2::ZERO)
  end
end
