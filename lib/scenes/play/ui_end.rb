# frozen_string_literal: true

require_relative '../scene'

# PlayScene's end game UI
class PlayUIEndScene < Scene
  def initialize(window, play_scene)
    super(window)

    @play_scene = play_scene

    @play_again_button = Button.new(
      @window,
      'Play Again',
      Constant::FONT_SM,
      @window.width / 2.0 - 10,
      @window.height * 2 / 3.0,
      ZOrder::UI,
      -> { @window.go_to_scene(PlayScene) },
      1,
      0.5,
      5
    )

    @menu_button = Button.new(
      @window,
      'Main Menu',
      Constant::FONT_SM,
      @window.width / 2.0 + 10,
      @window.height * 2 / 3.0,
      ZOrder::UI,
      -> { @window.go_to_scene(MenuScene) },
      0,
      0.5,
      5
    )
  end

  def button_up(id)
    @play_again_button.button_up(id)
    @menu_button.button_up(id)
  end

  def update
    @play_again_button.update
    @menu_button.update
  end

  def draw
    # Draw game over
    Constant::FONT_LG.draw_text_rel(
      'Game Over',
      @window.width / 2.0,
      @window.height / 3.0,
      ZOrder::UI,
      0.5,
      0.5
    )

    # Draw score
    Constant::FONT_MD.draw_text_rel(
      'Score: ' + @play_scene.score.to_s,
      @window.width / 2.0,
      @window.height / 2.0,
      ZOrder::UI,
      0.5,
      0.5
    )

    @play_again_button.draw
    @menu_button.draw
  end
end
