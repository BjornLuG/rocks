# frozen_string_literal: true

require_relative 'sprite'

# The floating rocks
class Rock < Sprite
  # All rock images' paths
  @@rocks = Dir[File.join(Dir.pwd, 'lib/assets/images/rocks/*')].sort

  def initialize(space, rock_index = nil)
    img = rock_index.nil? ? random_rock_image : rock_image(rock_index)
    radius = [img.width, img.height].max / 2.0
    body = CP::Body.new(
      radius,
      CP.moment_for_circle(radius, 0, radius, CP::Vec2::ZERO)
    )
    shape = CP::Shape::Circle.new(body, radius, CP::Vec2::ZERO)

    super(space, img, shape, ZOrder::ROCK)
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
    @active = false
  end

  private

  def rock_image(index)
    Gosu::Image.new(@@rocks[index % @@rocks.count])
  end

  def random_rock_image
    rock_image(rand(@@rocks.count))
  end
end
