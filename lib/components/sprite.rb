# frozen_string_literal: true

# Base class for objects that take part in physics
class Sprite
  attr_reader :shape

  def initialize(space, img, shape, zorder)
    @img = img
    @shape = shape
    @zorder = zorder

    space.add_shape(shape)
    space.add_body(shape.body)
  end

  def draw
    @img.draw_rot(
      @shape.body.p.x,
      @shape.body.p.y,
      @zorder,
      @shape.body.a.radians_to_gosu
    )
  end
end
