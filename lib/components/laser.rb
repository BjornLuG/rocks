# frozen_string_literal: true

require_relative 'sprite'

# The player ship
class Laser < Sprite
  attr_reader :has_exited

  def initialize
    super(Gosu::Image.new('lib/assets/images/laser.png'), ZOrder::LASER)

    @has_exited = false
  end

  def update(dt)
    super(dt)
    update_exit_state
  end

  def shoot(start_pos)
    @pos = start_pos
    @rot = -Math::PI / 2.0
    @velocity = Vector[0, -Constant::LASER_SPEED]
  end

  # Object pool functions

  def pool_create
    @active = false
  end

  def pool_spawn
    @active = true
  end

  def pool_despawn
    @pos = Vector[0.0, 0.0]
    @rot = 0.0
    @velocity = Vector[0.0, 0.0]
    @rot_velocity = 0.0
    @active = false
    @has_exited = false
  end

  private

  # Checks whether have exited screen
  def update_exit_state
    return unless @active

    return if @has_exited

    # y axis is negative means out of bounds since laser shoots up
    @has_exited = @pos[1].negative?
  end
end
