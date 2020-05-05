# frozen_string_literal: true

require_relative 'scene'

# The highscore scene
class HighscoreScene < Scene
  def initialize(window)
    super(window)

    @menu_button = Button.new(
      @window,
      'Menu',
      Constant::FONT_SM,
      @window.width / 2.0,
      @window.height - 100,
      ZOrder::UI,
      -> { @window.go_to_scene(MenuScene) },
      0.5,
      0,
      5
    )

    @highscore_manager = HighscoreManager.new

    @window.menu_music.play(true)
  end

  def button_up(id)
    @menu_button.button_up(id)
  end

  def update(_dt)
    @menu_button.update
  end

  def draw
    # Draw app name
    Constant::FONT_MD.draw_text_rel(
      'Highscores',
      @window.width / 2.0,
      100,
      ZOrder::UI,
      0.5,
      1
    )

    draw_scores(100)

    # Draw play button
    @menu_button.draw
  end

  private

  def draw_scores(start_y)
    y_separation = Constant::FONT_SM.height + 5

    @highscore_manager.score_list.each_with_index do |item, index|
      Constant::FONT_SM.draw_text_rel(
        item['name'],
        @window.width / 4,
        start_y + y_separation * index,
        ZOrder::UI,
        0,
        0
      )

      Constant::FONT_SM.draw_text_rel(
        item['score'],
        @window.width * 3 / 4,
        start_y + y_separation * index,
        ZOrder::UI,
        1,
        0
      )
    end
  end
end
