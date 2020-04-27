# frozen_string_literal: true

require_relative 'sprite'

# The player ship
class Ship < Sprite
  attr_reader :health

  def initialize(window, laser_pool, specs)
    super(Gosu::Image.new('lib/assets/images/ship.png'), ZOrder::SHIP)

    @window = window
    @laser_pool = laser_pool
    @specs = specs

    @health = specs[:health]

    # Cache last shoot time to calculate shoot interval
    @last_shoot_ms = Gosu.milliseconds
  end

  def update(dt)
    super(dt)
    update_position
    shoot if @window.button_down?(Gosu::MS_LEFT) && can_shoot
  end

  def take_damage
    @health -= 1
  end

  def dead?
    @health <= 0
  end

  private

  def can_shoot
    if Gosu.milliseconds - @last_shoot_ms > @specs[:shoot_interval]
      @last_shoot_ms = Gosu.milliseconds
      true
    else
      false
    end
  end

  def update_position
    @pos[0] = [0, @window.mouse_x, @window.width].sort[1]
  end

  def shoot
    @laser_pool.spawn&.shoot(@pos)
  end
end
