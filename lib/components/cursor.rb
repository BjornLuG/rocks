# frozen_string_literal: true

# The cursor display state
module CursorState
  NORMAL, HOVER, ACTIVE, HIDE = *0..3
end

# The mouse cursor
class Cursor
  attr_accessor :visible, :state

  def initialize(window)
    @window = window
    @img_normal = Gosu::Image.new(Constant::CURSOR_IMG_NORMAL_NAME)
    @img_hover = Gosu::Image.new(Constant::CURSOR_IMG_HOVER_NAME)
    @img_active = Gosu::Image.new(Constant::CURSOR_IMG_ACTIVE_NAME)
    @visible = true
    @state = CursorState::NORMAL
  end

  def draw
    # Draw cursor image if set to visible and is in window bounds
    if @visible && in_window?
      current_img&.draw(
        @window.mouse_x - current_img.width / 2,
        @window.mouse_y - current_img.height / 2,
        ZOrder::CURSOR
      )
    end
  end

  private

  def current_img
    case @state
    when CursorState::NORMAL
      @img_normal
    when CursorState::HOVER
      @img_hover
    when CursorState::ACTIVE
      @img_active
    end
  end

  def in_window?
    Util.point_in_rect?(
      @window.mouse_x,
      @window.mouse_y,
      0,
      0,
      @window.width,
      @window.height
    )
  end
end
