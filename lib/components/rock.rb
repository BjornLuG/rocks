# frozen_string_literal: true

require_relative 'sprite'

# The floating rocks
class Rock < Sprite
  # All rock images' paths
  @@rocks = Dir[File.join(Dir.pwd, 'lib/assets/images/rocks/*')].sort

  attr_reader :has_entered, :has_exited

  def initialize(window, space, rock_index = nil)
    img = rock_index.nil? ? random_rock_image : rock_image(rock_index)
    radius = [img.width, img.height].max / 2.0
    body = CP::Body.new(
      radius,
      CP.moment_for_circle(radius, 0, radius, CP::Vec2::ZERO)
    )
    shape = CP::Shape::Circle.new(body, radius, CP::Vec2::ZERO)
    shape.layers = CollisionLayer::ROCK
    # Prevent colissions between other rocks
    shape.group = 1

    super(space, img, shape, ZOrder::ROCK)

    @window = window
    @radius = radius

    # Whether rock has entered and exited the window (out of view)
    @has_entered = false
    @has_exited = false
  end

  def update
    update_enter_exit_state
  end

  # Targets a ship from a random position on window edge with random torque,
  # random speed and random size
  def target_ship(ship_pos)
    start_pos = random_start_pos

    normalized_direction = (ship_pos - start_pos).normalize_safe

    @shape.body.p = start_pos

    @shape.body.apply_force(normalized_direction * 100.0, CP::Vec2::ZERO)
  end

  def new_rock_image(index)
    @img = rock_image(index)
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
    @shape.body.reset_forces
    @active = false
    @has_entered = false
    @has_exited = false
  end

  private

  def update_enter_exit_state
    return unless @active

    return if @has_exited

    is_in_view = Util.point_in_rect?(
      @shape.body.p,
      @window.width,
      @window.height
    )

    if !@has_entered
      # Never entered, check entered
      @has_entered = is_in_view
    else
      # Else entered before, we check exit
      @has_exited = !is_in_view
    end
  end

  def rock_image(index)
    Gosu::Image.new(@@rocks[index % @@rocks.count])
  end

  def random_rock_image
    rock_image(rand(@@rocks.count))
  end

  # Randomly choose a starting point at the edge of the window
  # Also takes into account of its radius
  def random_start_pos
    Util.random_on_rect_edge(
      @window.width + @radius * 2,
      @window.height + @radius * 2
    ) - CP::Vec2.new(@radius, @radius)
  end
end
