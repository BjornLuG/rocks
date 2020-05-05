# frozen_string_literal: true

# The main game class
class Game < Gosu::Window
  attr_reader :game_music, :menu_music

  def initialize
    super(Constant::WINDOW_WIDTH, Constant::WINDOW_HEIGHT, false)

    self.caption = Constant::APP_NAME

    @background = Gosu::Image.new(Constant::BG_IMAGE_NAME)

    # Mouse cursor image
    @cursor = Cursor.new(self)

    # Setup music
    @game_music = Gosu::Song.new(Constant::GAME_MUSIC_NAME)
    @menu_music = Gosu::Song.new(Constant::MENU_MUSIC_NAME)

    # Reduce game music's volume, because it's loud
    @game_music.volume = 0.25

    # Update delta time
    @prev_ms = Gosu.milliseconds
    @dt = 0

    @current_scene = MenuScene.new(self)
  end

  def button_down(id)
    @current_scene.button_down(id) if @current_scene.respond_to? :button_down
  end

  def button_up(id)
    @current_scene.button_up(id) if @current_scene.respond_to? :button_up
  end

  def update
    update_dt
    update_cursor
    @current_scene.update(@dt) if @current_scene.respond_to? :update
  end

  def draw
    draw_background
    @cursor.draw
    @current_scene.draw if @current_scene.respond_to? :draw
  end

  def go_to_scene(scene_class)
    @current_scene = scene_class.new(self)
  end

  private

  def update_dt
    @dt = Gosu.milliseconds - @prev_ms
    @prev_ms = Gosu.milliseconds
  end

  def draw_background
    @background.draw(
      0,
      0,
      ZOrder::BACKGROUND,
      width.to_f / @background.width,
      height.to_f / @background.height
    )
  end

  def update_cursor
    @cursor.state =
      if button_down?(Gosu::MS_LEFT)
        CursorState::ACTIVE
      else
        CursorState::NORMAL
      end
  end
end
