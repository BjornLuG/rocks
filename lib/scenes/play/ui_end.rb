# frozen_string_literal: true

require_relative '../scene'

# PlayScene's end game UI
class PlayUIEndScene < Scene
  def initialize(window, play_scene)
    super(window)

    @play_scene = play_scene

    @highscore_manager = HighscoreManager.new

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

    @name_input = TextInput.new(
      @window,
      Constant::FONT_SM,
      @window.width / 2.0 - 150,
      @window.height / 2.0 + 40,
      ZOrder::UI,
      300,
      'Enter name'
    )

    @done_button = Button.new(
      @window,
      'Done',
      Constant::FONT_SM,
      @window.width / 2.0,
      @window.height / 2.0 + 120,
      ZOrder::UI,
      lambda {
        @highscore_manager.add_highscore(@name_input.text, @play_scene.score)
        @window.go_to_scene(HighscoreScene)
      },
      0.5,
      0.5,
      5
    )
  end

  def button_down(id)
    @name_input.button_down(id)
  end

  def button_up(id)
    @play_again_button.button_up(id)
    @menu_button.button_up(id)
    @done_button.button_up(id)
  end

  def update
    if highscore?
      @name_input.update
      @done_button.update
    else
      @play_again_button.update
      @menu_button.update
    end
  end

  def draw
    draw_game_over
    draw_score

    # Show different views depednign if have highscore
    if highscore?
      # Input name and transition to highscore view
      @name_input.draw
      @done_button.draw
    else
      # Play again or menu button
      @play_again_button.draw
      @menu_button.draw
    end
  end

  private

  def highscore?
    @highscore_manager.highscore?(@play_scene.score)
  end

  def draw_game_over
    Constant::FONT_LG.draw_text_rel(
      'Game Over',
      @window.width / 2.0,
      @window.height / 3.0,
      ZOrder::UI,
      0.5,
      0.5
    )
  end

  def draw_score
    text = (highscore? ? 'New highscore: ' : 'Score: ') + @play_scene.score.to_s

    Constant::FONT_MD.draw_text_rel(
      text,
      @window.width / 2.0,
      @window.height / 2.0,
      ZOrder::UI,
      0.5,
      0.5
    )
  end
end
