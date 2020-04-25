# frozen_string_literal: true

# The main game class
class Game < Gosu::Window
  def initialize
    super(Constants::WINDOW_WIDTH, Constants::WINDOW_HEIGHT, false)

    self.caption = Constants::APP_NAME

    # Fixed dt to improve chipmunk performance
    @dt = 1.0 / 60.0

    @background = Gosu::Image.new('lib/assets/images/background.png')

    @cursor = Cursor.new(self)

    @space = CP::Space.new
    @space.damping = 0.8

    init_ship

    @rock_pool = Pool.new(-> { Rock.new(@space) }, 20)

    @prev_rock_spawn_ms = Gosu.milliseconds
  end

  def update
    update_cursor
    update_rock_spawn
    @ship.update
    @space.step(@dt)
  end

  def draw
    draw_background
    @cursor.draw
    @ship.draw
    @rock_pool.active_objects.each(&:draw)
  end

  private

  def init_ship
    @ship = Ship.new(
      self,
      @space,
      {
        mass: 10.0,
        inertia: 15.0,
        shoot_interval: 300
      }
    )

    @ship.shape.body.p = CP::Vec2.new(
      Constants::WINDOW_WIDTH / 2.0,
      Constants::WINDOW_HEIGHT / 2.0
    )
  end

  def draw_background
    @background.draw(
      0,
      0,
      ZOrder::BACKGROUND,
      Constants::WINDOW_WIDTH.to_f / @background.width,
      Constants::WINDOW_HEIGHT.to_f / @background.height
    )
  end

  def update_cursor
    @cursor.state = if button_down?(Gosu::MS_LEFT)
                      CursorState::ACTIVE
                    else
                      CursorState::NORMAL
                    end
  end

  def update_rock_spawn
    return unless Gosu.milliseconds - @prev_rock_spawn_ms > 1000

    rock = @rock_pool.spawn

    return if rock.nil?

    rock.shape.body.p = CP::Vec2.new(
      rand * Constants::WINDOW_WIDTH,
      rand * Constants::WINDOW_HEIGHT
    )

    @prev_rock_spawn_ms = Gosu.milliseconds
  end
end
