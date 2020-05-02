# frozen_string_literal: true

require_relative 'scene'

# The main menu scene
class MenuScene < Scene
  def initialize(window)
    super(window)

    @play_button = Button.new(
      @window,
      'Play',
      Constant::FONT_SM,
      @window.width / 2.0,
      @window.height / 2.0,
      ZOrder::UI,
      -> { @window.go_to_scene(PlayScene) },
      0.5,
      0,
      5
    )

    @highscore_button = Button.new(
      @window,
      'Highscore',
      Constant::FONT_SM,
      @window.width / 2.0,
      @window.height / 2.0 + @play_button.bordered_height + 10,
      ZOrder::UI,
      -> { @window.go_to_scene(HighscoreScene) },
      0.5,
      0,
      5
    )
  end

  def button_up(id)
    @play_button.button_up(id)
    @highscore_button.button_up(id)
  end

  def update(_dt)
    @play_button.update
    @highscore_button.update
  end

  def draw
    # Draw app name
    Constant::FONT_XL.draw_text_rel(
      Constant::APP_NAME,
      @window.width / 2.0,
      @window.height / 3.0,
      ZOrder::UI,
      0.5,
      0.5
    )

    @play_button.draw
    @highscore_button.draw
  end
end
