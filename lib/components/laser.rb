# frozen_string_literal: true

require_relative 'sprite'

# The player ship
class Laser < Sprite
  attr_reader :has_exited

  def initialize(window, space, specs)
    img = Gosu::Image.new('lib/assets/images/laser.png')
    body = CP::Body.new(
      specs[:mass],
      CP.moment_for_box(specs[:mass], img.width, img.height)
    )
    radius = img.width / 2.0
    half_height = img.height / 2.0
    shape = CP::Shape::Poly.new(
      body,
      [
        CP::Vec2.new(-radius, -half_height),
        CP::Vec2.new(-radius, half_height),
        CP::Vec2.new(radius, half_height),
        CP::Vec2.new(radius, -half_height)
      ],
      CP::Vec2::ZERO
    )
    shape.collision_type = :laser
    shape.layers = CollisionLayer::LASER
    # Prevent collisions between other lasers
    shape.group = CollisionLayer::LASER
    shape.object = self

    super(space, img, shape, ZOrder::LASER)

    @window = window

    @has_exited = false
  end

  def update
    update_exit_state
  end

  def target_direction(start_pos, direction)
    direction = direction.normalize_safe
    @shape.body.p = start_pos
    @shape.body.a = Math.atan2(direction.y, direction.x)
    @shape.body.apply_impulse(direction * 400, CP::Vec2::ZERO)
  end

  def pool_create
    remove_from_space
    @active = false
  end

  def pool_spawn
    add_to_space
    @active = true
  end

  def pool_despawn
    remove_from_space
    reset_shape_physics
    @active = false
    @has_exited = false
  end

  private

  def update_exit_state
    return unless @active

    return if @has_exited

    @has_exited = !Util.point_in_rect?(
      @shape.body.p,
      @window.width,
      @window.height
    )
  end
end
