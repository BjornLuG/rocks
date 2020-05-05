# frozen_string_literal: true

module Constant
  # General
  APP_NAME = 'Rocks'
  WINDOW_WIDTH = 700
  WINDOW_HEIGHT = 500
  WINDOW_PADDING = 50
  HIGHSCORE_FILE_NAME = '.data/highscore.json'
  BG_IMAGE_NAME = 'lib/assets/images/background.png'

  # Font
  FONT_NAME = 'lib/assets/fonts/kenvector_future.ttf'
  FONT_SM = Gosu::Font.new(24, { name: FONT_NAME })
  FONT_MD = Gosu::Font.new(56, { name: FONT_NAME })
  FONT_LG = Gosu::Font.new(80, { name: FONT_NAME })
  FONT_XL = Gosu::Font.new(120, { name: FONT_NAME })

  # Sounds
  GAME_MUSIC_NAME = 'lib/assets/sound/music/game.mp3'
  MENU_MUSIC_NAME = 'lib/assets/sound/music/menu.mp3'
  CLICK_SFX_NAME = 'lib/assets/sound/sfx/click.ogg'
  CRASH_SFX_NAME = 'lib/assets/sound/sfx/crash.ogg'
  HURT_SFX_NAME = 'lib/assets/sound/sfx/hurt.ogg'
  SHOOT_SFX_NAME = 'lib/assets/sound/sfx/shoot.ogg'

  # Game settings
  # Laser
  LASER_SPEED = 600

  # Ship
  SHIP_IMG_NAME = 'lib/assets/images/ship.png'
  SHIP_HEALTH = 3
  SHIP_SHOOT_INTERVAL = 200 # In milliseconds

  # Rock
  ROCK_ALL_IMG_NAME = Dir[File.join(Dir.pwd, 'lib/assets/images/rocks/*')].sort
  ROCK_AVERAGE_SPEED = 1500 # Value derived testing
  ROCK_AVERAGE_ROT_SPEED = 20 # Value derived testing
  ROCK_SPAWN_INTERVAL = 300 # In milliseconds

  # Cursor
  CURSOR_IMG_NORMAL_NAME = 'lib/assets/images/cursor/normal.png'
  CURSOR_IMG_HOVER_NAME = 'lib/assets/images/cursor/active.png'
  CURSOR_IMG_ACTIVE_NAME = 'lib/assets/images/cursor/active.png'
end
