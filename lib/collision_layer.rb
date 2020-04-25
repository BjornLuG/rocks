# frozen_string_literal: true

# Collision logic:
# Laser collide rock
# Rock collide ship
# Laser doesn't collide ship

# Chipmunk physics collision layers
# http://chipmunk-rb.github.io/chipmunk/#CollisionDetection
module CollisionLayer
  LASER = 0b0001
  SHIP = 0b0010
  ROCK = 0b0011
end
