# frozen_string_literal: true

require_relative 'scene'

# The gameplay scene
class PlayScene < Scene
  def initialize(window)
    super(window)

    @rock_pool = Pool.new(-> { Rock.new(@window, 0) }, 20)
    @laser_pool = Pool.new(-> { Laser.new }, 20)

    # To keep track of rock spawn
    @prev_rock_spawn_ms = Gosu.milliseconds

    @game_ended = false

    @menu_button = Button.new(
      @window,
      'Main Menu',
      Constant::FONT_SM,
      @window.width / 2.0,
      @window.height * 2 / 3.0,
      ZOrder::UI,
      -> { @window.go_to_scene(MenuScene) },
      0.5,
      0.5,
      5
    )

    init_ship
  end

  def button_up(id)
    @menu_button.button_up(id)
  end

  def update(dt)
    if @game_ended
      @menu_button.update
    else
      update_rock_spawn

      check_laser_rock_collision
      check_ship_rock_collision

      @ship.update(dt)

      @rock_pool.active_objects.each do |rock|
        rock.update(dt)
        @rock_pool.despawn(rock) if rock.has_exited
      end

      @laser_pool.active_objects.each do |laser|
        laser.update(dt)
        @laser_pool.despawn(laser) if laser.has_exited
      end
    end
  end

  def draw
    @menu_button.draw if @game_ended

    @ship.draw
    @rock_pool.active_objects.each(&:draw)
    @laser_pool.active_objects.each(&:draw)
  end

  private

  def init_ship
    @ship = Ship.new(
      @window,
      @laser_pool,
      {
        health: 3,
        shoot_interval: 200
      }
    )

    @ship.pos = Vector[
      @window.width / 2.0,
      @window.height - @ship.collider_radius
    ]

    @ship.rot = -Math::PI / 2.0
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
    @game_ended = true
    puts 'Game over'
  end
end
