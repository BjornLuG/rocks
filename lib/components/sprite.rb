# frozen_string_literal: true

# Base class for objects that take part in physics
class Sprite
  attr_accessor :img, :zorder, :pos, :rot, :collider_radius, :velocity,
                :rot_velocity, :active

  def initialize(img, zorder)
    @img = img
    @zorder = zorder
    # Vector 2 position
    @pos = Vector[0.0, 0.0]
    # Rotation in radians
    @rot = 0.0
    @collider_radius = [@img.width, @img.height].max / 2.0
    @velocity = Vector[0.0, 0.0]
    @rot_velocity = 0.0
    @active = true
  end

  def update(dt)
    @pos += @velocity * dt / 1000
    @rot += @rot_velocity * dt / 1000
  end

  def draw
    return unless @active

    @img.draw_rot(
      @pos[0],
      @pos[1],
      @zorder,
      @rot.radians_to_gosu
    )
  end

  # Collision detection
  def collide?(other_sprite)
    # Relative distance
    x_dist = (other_sprite.pos[0] - @pos[0]).abs
    y_dist = (other_sprite.pos[1] - @pos[1]).abs

    # Min collision distance
    collide_dist = @collider_radius + other_sprite.collider_radius

    # Preliminary check if x, y distance is more than collide.
    # This is much efficient to run than below.
    return false if x_dist >= collide_dist || y_dist >= collide_dist

    # Here we compare by power of 2 because square root is expensive.
    square_dist = x_dist**2 + y_dist**2
    square_collision_dist = collide_dist**2
    square_dist < square_collision_dist
  end
end
