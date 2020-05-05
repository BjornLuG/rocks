# frozen_string_literal: true

# UI Button class
class Button
  attr_reader :rect_width, :rect_height, :bordered_width, :bordered_height

  def initialize(
    window,
    text,
    font,
    x,
    y,
    z,
    on_click,
    rel_x = 0,
    rel_y = 0,
    border_width = 0,
    bg_color = Gosu::Color::WHITE,
    text_color = Gosu::Color::BLACK,
    border_color = Gosu::Color::GRAY
  )
    @window = window
    @text = text
    @font = font
    @x = x
    @y = y
    @z = z
    @on_click = on_click
    @rel_x = rel_x
    @rel_y = rel_y
    @border_width = border_width
    @bg_color = bg_color
    @text_color = text_color
    @border_color = border_color

    # Rect properties
    @text_width = 0
    @rect_width = 0
    @rect_height = 0
    @bordered_width = 0
    @bordered_height = 0
    # Top left corner properties with account to relative x,y and border
    @anchor_x = 0
    @anchor_y = 0

    @button_click_up = false
    @click_sfx = Gosu::Sample.new(Constant::CLICK_SFX_NAME)

    update_rect_properties
  end

  def button_up(id)
    @button_click_up = mouse_in_rect? && id == Gosu::MS_LEFT
    @click_sfx.play if @button_click_up
  end

  def update
    update_rect_properties

    @on_click.call if @button_click_up
  end

  def draw
    # Initialize temporary colors so that we can modify it
    # Change color alpha depending on hover.
    # Default is half transparent so players can see objects behind.
    alpha = mouse_in_rect? ? 1 : 0.6

    temp_bg_color = Util.gosu_color_change_alpha(@bg_color, alpha)
    temp_text_color = Util.gosu_color_change_alpha(@text_color, alpha)
    temp_border_color = Util.gosu_color_change_alpha(@border_color, alpha)

    if @border_width.positive?
      # Draw border rect
      Gosu.draw_rect(
        @anchor_x,
        @anchor_y,
        @bordered_width,
        @bordered_height,
        temp_border_color,
        @z
      )
    end

    Gosu.draw_rect(
      @anchor_x + @border_width,
      @anchor_y + @border_width,
      @rect_width,
      @rect_height,
      temp_bg_color,
      @z
    )

    @font.draw_text_rel(
      @text,
      @anchor_x + @bordered_width / 2.0,
      @anchor_y + @bordered_height / 2.0,
      @z,
      0.5,
      0.5,
      1,
      1,
      temp_text_color
    )
  end

  private

  def update_rect_properties
    @text_width = @font.text_width(@text)
    @rect_width = @text_width + @font.height * 2
    @rect_height = @font.height * 1.5
    @bordered_width = @rect_width + @border_width * 2
    @bordered_height = @rect_height + @border_width * 2
    @anchor_x = @x - Util.lerp(0, @bordered_width, @rel_x)
    @anchor_y = @y - Util.lerp(0, @bordered_height, @rel_y)
  end

  def mouse_in_rect?
    Util.point_in_rect?(
      @window.mouse_x,
      @window.mouse_y,
      @anchor_x,
      @anchor_y,
      @bordered_width,
      @bordered_height
    )
  end
end
