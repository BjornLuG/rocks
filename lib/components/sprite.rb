# frozen_string_literal: true

# Base class for objects that take part in physics
class Sprite
  attr_accessor :img, :shape, :active

  def initialize(space, img, shape, zorder)
    @space = space
    @img = img
    @shape = shape
    @zorder = zorder
    @active = true

    add_to_space
  end

  def draw
    return unless @active

    @img.draw_rot(
      @shape.body.p.x,
      @shape.body.p.y,
      @zorder,
      @shape.body.a.radians_to_gosu
    )
  end

  def add_to_space
    @space.add_shape(@shape)
    @space.add_body(@shape.body)
  end

  def remove_from_space
    @space.remove_shape(@shape)
    @space.remove_body(@shape.body)
  end
end
