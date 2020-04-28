# frozen_string_literal: true

require_relative '../scene'

# PlayScene's main UI
class PlayUIMainScene < Scene
  def initialize(window, play_scene)
    super(window)

    @play_scene = play_scene

    @pause_button = Button.new(
      @window,
      'Pause',
      Constant::FONT_SM,
      @window.width,
      0,
      ZOrder::UI,
      lambda {
        @play_scene.paused = true
        @play_scene.go_to_ui_scene(PlayUIPauseScene)
      },
      1,
      0,
      5
    )
  end

  def button_up(id)
    if id == Gosu::KB_SPACE
      @play_scene.paused = true
      @play_scene.go_to_ui_scene(PlayUIPauseScene)
    else
      @pause_button.button_up(id)
    end
  end

  def update
    @pause_button.update
  end

  def draw
    # Draw score
    Constant::FONT_MD.draw_text_rel(
      @play_scene.score.to_s,
      0,
      0,
      ZOrder::UI,
      0,
      0
    )

    @pause_button.draw
  end
end
