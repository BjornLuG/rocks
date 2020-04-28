# frozen_string_literal: true

# The scene base class
class Scene
  # Main constructor. Inherited classes should not extend this constructor
  def initialize(window)
    @window = window
  end
end
