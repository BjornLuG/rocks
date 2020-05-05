# frozen_string_literal: true

require_relative 'sprite'

# The player ship
class Ship < Sprite
  attr_reader :health

  def initialize(window, laser_pool)
    super(Gosu::Image.new(Constant::SHIP_IMG_NAME), ZOrder::SHIP)

    @window = window
    @laser_pool = laser_pool

    @health = Constant::SHIP_HEALTH

    # Cache last shoot time to calculate shoot interval
    @last_shoot_ms = Gosu.milliseconds

    @shoot_sfx = Gosu::Sample.new(Constant::SHOOT_SFX_NAME)
    @hurt_sfx = Gosu::Sample.new(Constant::HURT_SFX_NAME)
  end

  def update(dt)
    super(dt)
    update_position
    shoot if @window.button_down?(Gosu::MS_LEFT) && can_shoot
  end

  def take_damage
    @health -= 1
    @hurt_sfx.play
  end

  def dead?
    @health <= 0
  end

  private

  def can_shoot
    if Gosu.milliseconds - @last_shoot_ms > Constant::SHIP_SHOOT_INTERVAL
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
    laser = @laser_pool.spawn

    return if laser.nil?

    laser.shoot(@pos)
    @shoot_sfx.play(0.6)
  end
end
