require 'gosu'
require_relative 'zorder'

module CursorState
  Normal, Hover, Active, Hide = *0..3
end

class Cursor
  attr_accessor :visible, :state

  def initialize(window)
    @window = window
    @imgNormal = Gosu::Image.new('src/assets/images/cursor/normal.png')
    @imgHover = Gosu::Image.new('src/assets/images/cursor/active.png')
    @imgActive = Gosu::Image.new('src/assets/images/cursor/active.png')
    @visible = true
    @state = CursorState::Normal
  end

  def draw
    if @visible
      current_img = get_current_img

      if current_img
        current_img.draw(@window.mouse_x - current_img.width / 2, @window.mouse_y - current_img.height / 2, ZOrder::Cursor)
      end
    end
  end

  private

  def get_current_img
    case @state
    when CursorState::Normal
      return @imgNormal
    when CursorState::Hover
      return @imgHover
    when CursorState::Active
      return @imgActive
    else
      return nil
    end
  end
end
