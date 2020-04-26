# frozen_string_literal: true

# The main game class
class Game < Gosu::Window
  def initialize
    super(Constant::WINDOW_WIDTH, Constant::WINDOW_HEIGHT, false)

    self.caption = Constant::APP_NAME

    # Fixed dt to improve chipmunk performance
    @dt = 1.0 / 60.0

    @background = Gosu::Image.new('lib/assets/images/background.png')

    @cursor = Cursor.new(self)

    @space = CP::Space.new
    @space.damping = 0.8

    @rock_pool = Pool.new(-> { Rock.new(self, @space, 0) }, 20)

    @prev_rock_spawn_ms = Gosu.milliseconds

    # Used for Chipmunk since you cannot remove shapes/bodies during a step.
    # This will be called after the step
    @late_update_stack = []

    init_ship

    handle_rock_ship_collision
  end

  def update
    update_cursor
    update_rock_spawn

    @ship.update

    @space.step(@dt)

    @rock_pool.active_objects.each do |rock|
      rock.update
      @rock_pool.despawn(rock) if rock.has_exited
    end

    late_update
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
        health: 3,
        mass: 10.0,
        inertia: 15.0,
        shoot_interval: 300
      }
    )

    @ship.shape.body.p = CP::Vec2.new(width / 2.0, height / 2.0)
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

  def late_update
    @late_update_stack.each(&:call)
    @late_update_stack.clear
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

    rock.change_rock
    rock.target_ship(@ship.shape.body.p)

    @prev_rock_spawn_ms = Gosu.milliseconds
  end

  def handle_rock_ship_collision
    @space.add_collision_func(:rock, :ship) do |rock_shape, _ship_shape|
      @ship.take_damage

      @late_update_stack.push(lambda {
        @rock_pool.despawn(rock_shape.object)
      })

      end_game if @ship.dead?
    end
  end

  def end_game
    puts 'Game over'
  end
end
