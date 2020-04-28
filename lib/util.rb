# frozen_string_literal: true

# Various utility code
module Util
  # Linearly interpolate between a and b by t, where t is value from 0 to 1.
  # If t = 0, return a. If t = 1, return b.
  def self.lerp(a, b, t)
    a + (b - a) * t
  end

  # Check if point is in the rect
  def self.point_in_rect?(
    point_x,
    point_y,
    rect_x,
    rect_y,
    rect_width,
    rect_height
  )
    point_x >= rect_x && point_x <= rect_x + rect_width &&
      point_y >= rect_y && point_y <= rect_y + rect_height
  end

  # Returns new color with alpha of value between 0 to 1.
  # I did not copy this.
  def self.gosu_color_change_alpha(color, value)
    # Convert value to 2^8 which means 0xff and floor it
    alpha_hex = (value * 256).floor.clamp(0, 255)

    # Extract the rgb values and combine with alpha hex.
    # Alpha hex is shited 24 bits because rgb takes 24 bits
    result_hex = (color.argb & 0x00_ffffff) | (alpha_hex << 24)
    Gosu::Color.new(result_hex)
  end
end
