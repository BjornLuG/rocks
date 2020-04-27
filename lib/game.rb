# frozen_string_literal: true

# The main game class
class Game < Gosu::Window
  def initialize
    super(Constant::WINDOW_WIDTH, Constant::WINDOW_HEIGHT, false)

    self.caption = Constant::APP_NAME

    @background = Gosu::Image.new('lib/assets/images/background.png')

    @cursor = Cursor.new(self)

    @rock_pool = Pool.new(-> { Rock.new(self, 0) }, 20)
    @laser_pool = Pool.new(-> { Laser.new }, 20)

    # To keep track of rock spawn
    @prev_rock_spawn_ms = Gosu.milliseconds

    # Update delta time
    @prev_ms = Gosu.milliseconds
    @dt = 0

    init_ship
  end

  def update
    update_dt
    update_cursor
    update_rock_spawn

    check_laser_rock_collision
    check_ship_rock_collision

    @ship.update(@dt)

    @rock_pool.active_objects.each do |rock|
      rock.update(@dt)
      @rock_pool.despawn(rock) if rock.has_exited
    end

    @laser_pool.active_objects.each do |laser|
      laser.update(@dt)
      @laser_pool.despawn(laser) if laser.has_exited
    end
  end

  def draw
    draw_background
    @cursor.draw
    @ship.draw
    @rock_pool.active_objects.each(&:draw)
    @laser_pool.active_objects.each(&:draw)
  end

  private

  def init_ship
    @ship = Ship.new(
      self,
      @laser_pool,
      {
        health: 3,
        shoot_interval: 200
      }
    )

    @ship.pos = Vector[width / 2.0, height - @ship.collider_radius]
    @ship.rot = -Math::PI / 2.0
  end

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
    rock.target_ship

    @prev_rock_spawn_ms = Gosu.milliseconds
  end

  def check_laser_rock_collision
    # O(n^2) but it's simpler to implement, for now
    @laser_pool.active_objects.each do |laser|
      @rock_pool.active_objects.each do |rock|
        next unless laser.collide?(rock)

        @laser_pool.despawn(laser)
        @rock_pool.despawn(rock)

        # Add score
      end
    end
  end

  def check_ship_rock_collision
    @rock_pool.active_objects.each do |rock|
      next unless rock.collide?(@ship)

      @rock_pool.despawn(rock)
      @ship.take_damage

      end_game if @ship.dead?
    end
  end

  def end_game
    puts 'Game over'
  end
end
