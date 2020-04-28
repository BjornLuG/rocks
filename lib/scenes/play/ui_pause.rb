# frozen_string_literal: true

require_relative '../scene'

# PlayScene's pause UI
class PlayUIPauseScene < Scene
  def initialize(window, play_scene)
    super(window)

    @play_scene = play_scene

    @continue_button = Button.new(
      @window,
      'Menu',
      Constant::FONT_SM,
      @window.width / 2.0,
      @window.height * 2 / 3.0,
      ZOrder::UI,
      lambda {
        @play_scene.paused = false
        @play_scene.go_to_ui_scene(PlayUIMainScene)
      },
      0.5,
      0.5,
      5
    )
  end

  def button_up(id)
    if id == Gosu::KB_SPACE
      @play_scene.paused = false
      @play_scene.go_to_ui_scene(PlayUIMainScene)
    else
      @continue_button.button_up(id)
    end
  end

  def update
    @continue_button.update
  end

  def draw
    # Draw score
    Constant::FONT_LG.draw_text_rel(
      'Paused',
      @window.width / 2.0,
      @window.height / 3.0,
      ZOrder::UI,
      0.5,
      0.5
    )

    @continue_button.draw
  end
end
