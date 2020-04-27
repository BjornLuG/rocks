# frozen_string_literal: true

require 'matrix'
require 'gosu'

# Require all ruby files in lib
Dir[File.join(__dir__, 'lib/**/*.rb')].sort.each { |file| require file }

game = Game.new
game.show
