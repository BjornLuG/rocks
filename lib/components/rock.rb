# frozen_string_literal: true

require_relative 'sprite'

# The floating rocks
class Rock < Sprite
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
    @velocity = Vector[0, Constant::ROCK_AVERAGE_SPEED] / @collider_radius
    @rot_velocity = (rand - 0.5) * Constant::ROCK_AVERAGE_ROT_SPEED /
                    @collider_radius
  end

  def change_rock(index = nil)
    @img = index.nil? ? random_rock_image : rock_image(index)
    @collider_radius = [@img.width, @img.height].max / 2.0
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

    # Check if went below screen since it travels downwards
    @has_exited = @pos[1] > @window.height
  end

  # Get rock image based on index from rock image list
  def rock_image(index)
    all_img_count = Constant::ROCK_ALL_IMG_NAME.count
    Gosu::Image.new(Constant::ROCK_ALL_IMG_NAME[index % all_img_count])
  end

  def random_rock_image
    rock_image(rand(Constant::ROCK_ALL_IMG_NAME.count))
  end
end
