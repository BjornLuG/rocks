# frozen_string_literal: true

# Main text input
# Reference: https://github.com/gosu/gosu-examples/blob/master/examples/text_input.rb
class TextInput < Gosu::TextInput
  INACTIVE_COLOR    = 0xcc_666666
  ACTIVE_COLOR      = 0xcc_ff6666
  CARET_COLOR       = 0xff_ffffff
  PLACEHOLDER_COLOR = 0x88_ffffff
  TEXT_COLOR        = 0xff_ffffff

  attr_reader :x, :y

  def initialize(window, font, x, y, z, w, placeholder)
    super()

    @window = window
    @font = font
    @x = x
    @y = y
    @z = z
    @w = w
    @placeholder = placeholder

    update_rect
  end

  def button_down(id)
    if id == Gosu::MS_LEFT && mouse_in_rect?
      @window.text_input = self
      self.caret_pos = self.selection_start = text.length
    end
  end

  def update
    update_rect
  end

  def draw
    # Change background color if in focus
    bg_color = in_focus? ? ACTIVE_COLOR : INACTIVE_COLOR

    Gosu.draw_rect(@x, @y, @w, @rect_height, bg_color, @z)

    # Draw caret if focus
    if in_focus?
      pos_x = @x + @font.text_width(text[0...caret_pos]) + 10

      Gosu.draw_line(
        pos_x,
        @y,
        CARET_COLOR,
        pos_x,
        @y + @rect_height,
        CARET_COLOR,
        @z
      )
    end

    @font.draw_text_rel(
      text.empty? ? @placeholder : text,
      @x + 10,
      @y + @rect_height / 2,
      @z,
      0,
      0.5,
      1,
      1,
      text.empty? ? PLACEHOLDER_COLOR : TEXT_COLOR
    )
  end

  def in_focus?
    @window.text_input == self
  end

  private

  def update_rect
    @rect_height = @font.height * 1.5
  end

  def mouse_in_rect?
    Util.point_in_rect?(
      @window.mouse_x,
      @window.mouse_y,
      @x,
      @y,
      @w,
      @rect_height
    )
  end
end
