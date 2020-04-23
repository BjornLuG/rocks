class Sprite
  attr_reader :shape

  def initialize(img, shape, zorder)
    @img = img
    @shape = shape
    @zorder = zorder
  end

  def draw
    @img.draw_rot(@shape.body.p.x, @shape.body.p.y, @zorder, @shape.body.a.radians_to_gosu)
  end
end
