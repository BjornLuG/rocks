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
    @img_normal = Gosu::Image.new('lib/assets/images/cursor/normal.png')
    @img_hover = Gosu::Image.new('lib/assets/images/cursor/active.png')
    @img_active = Gosu::Image.new('lib/assets/images/cursor/active.png')
    @visible = true
    @state = CursorState::NORMAL
  end

  def draw
    return unless @visible

    current_img&.draw(
      @window.mouse_x - current_img.width / 2,
      @window.mouse_y - current_img.height / 2,
      ZOrder::CURSOR
    )
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
end
