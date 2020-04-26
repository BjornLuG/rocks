# frozen_string_literal: true

# Random utilities
module Util
  def self.random_on_rect_edge(width, height)
    rand_num = rand

    # Split to 4 equal chances for 4 sides of window
    if rand_num > 0.75
      # Left side
      CP::Vec2.new(0, rand * height)
    elsif rand_num > 0.5
      # Right side
      CP::Vec2.new(width, rand * height)
    elsif rand_num > 0.25
      # Top side
      CP::Vec2.new(rand * width, 0)
    else
      # Bottom side
      CP::Vec2.new(rand * width, height)
    end
  end

  def self.point_in_rect?(point, rect_width, rect_height)
    point.x >= 0 &&
      point.x <= rect_width &&
      point.y >= 0 &&
      point.y <= rect_height
  end
end
