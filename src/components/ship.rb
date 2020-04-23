require 'gosu'
require 'chipmunk'
require_relative 'sprite'
require_relative 'zorder'

class Ship < Sprite
  def initialize(space)
    img = Gosu::Image.new('src/assets/images/ship.png')
    radius = [img.width, img.height].max / 2.0
    body = CP::Body.new(10.0, 15.0)
    shape = CP::Shape::Circle.new(body, radius, CP::Vec2::ZERO)

    super(img, shape, ZOrder::Ship)

    space.add_body(body)
    space.add_shape(shape)
  end
end
