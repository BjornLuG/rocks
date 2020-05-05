# frozen_string_literal: true

require_relative 'sprite'

# The floating rocks
class Rock < Sprite
  # All rock images' paths
  @@rocks = Dir[File.join(Dir.pwd, 'lib/assets/images/rocks/*')].sort

  attr_reader :has_exited

  def initialize(window, rock_index = nil)
    super(
      rock_index.nil? ? random_rock_image : rock_image(rock_index),
      ZOrder::ROCK
    )

    @window = window

    # Whether rock has exited the window (out of view)
    @has_exited = false
  end

  def update(dt)
    super(dt)
    update_exit_state
  end

  # Targets a ship from a random position on window top edge
  def target_ship
    @pos = Vector[rand(@window.width), -@collider_radius]
    @velocity = Vector[0, 1500] / @collider_radius
    @rot_velocity = (rand - 0.5) * 20 / @collider_radius
  end

  def change_rock(index = nil)
    @img = index.nil? ? random_rock_image : rock_image(index)
    @collider_radius = [@img.width, @img.height].max / 2.0
  end

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

  def update_exit_state
    return unless @active

    return if @has_exited

    @has_exited = @pos[1] > @window.height
  end

  def rock_image(index)
    Gosu::Image.new(@@rocks[index % @@rocks.count])
  end

  def random_rock_image
    rock_image(rand(@@rocks.count))
  end
end
