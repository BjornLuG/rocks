# frozen_string_literal: true

require_relative 'scene'

# The gameplay scene
class PlayScene < Scene
  attr_accessor :score, :paused, :ship

  def initialize(window)
    super(window)

    @rock_pool = Pool.new(-> { Rock.new(@window, 0) }, 20)
    @laser_pool = Pool.new(-> { Laser.new }, 20)

    # To keep track of rock spawn
    @prev_rock_spawn_ms = Gosu.milliseconds

    @game_ended = false

    @score = 0
    @paused = false

    # Rock collide sound
    @crash_sfx = Gosu::Sample.new('lib/assets/sound/sfx/crash.ogg')

    @current_ui_scene = PlayUIMainScene.new(@window, self)

    init_ship

    @window.game_music.play(true)
  end

  def button_down(id)
    if @current_ui_scene.respond_to? :button_down
      @current_ui_scene.button_down(id)
    end
  end

  def button_up(id)
    @current_ui_scene.button_up(id) if @current_ui_scene.respond_to? :button_up
  end

  def update(dt)
    @current_ui_scene.update if @current_ui_scene.respond_to? :update

    return if @paused || @game_ended

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

  def draw
    @current_ui_scene.draw if @current_ui_scene.respond_to? :draw

    @ship.draw unless @game_ended

    @rock_pool.active_objects.each(&:draw)
    @laser_pool.active_objects.each(&:draw)
  end

  def go_to_ui_scene(scene_class)
    @current_ui_scene = scene_class.new(@window, self)
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

        @crash_sfx.play(0.6)

        # Add score
        @score += 1
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
    @window.game_music.pause
    go_to_ui_scene(PlayUIEndScene)
  end
end
