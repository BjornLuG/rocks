# frozen_string_literal: true

require_relative '../scene'

# PlayScene's main UI
class PlayUIMainScene < Scene
  def initialize(window, play_scene)
    super(window)

    @play_scene = play_scene

    @health_img = Gosu::Image.new('lib/assets/images/health.png')
  end

  def button_up(id)
    @play_scene.paused = !@play_scene.paused if id == Gosu::KB_SPACE
  end

  def draw
    # Draw health
    cumulative_pos_x = 10
    (1..@play_scene.ship.health).each do
      @health_img.draw(cumulative_pos_x, 10, ZOrder::UI)
      cumulative_pos_x += @health_img.width + 5
    end

    # Draw score
    Constant::FONT_MD.draw_text_rel(
      @play_scene.score.to_s,
      @window.width - 5,
      0,
      ZOrder::UI,
      1,
      0
    )

    if @play_scene.paused
      Constant::FONT_LG.draw_text_rel(
        'Paused',
        @window.width / 2.0,
        @window.height / 2.0,
        ZOrder::UI,
        0.5,
        0.5
      )
    end
  end
end
