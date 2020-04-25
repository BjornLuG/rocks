# frozen_string_literal: true

# The pool item for external object metadata
class PoolItem
  attr_accessor :active, :object

  def initialize(object)
    @active = false
    @object = object
  end
end

# The main object pool class
class Pool
  def initialize(spawn_object, pool_size, expandable = false)
    @spawn_object = spawn_object
    @item_stack = []
    @pool_size = pool_size
    @expandable = expandable

    init_stack
  end

  def spawn(force = false)
    found_item = nil

    # Find an inactive item to use
    @item_stack.each do |item|
      unless item.active
        found_item = item
        break
      end
    end

    if found_item.nil?
      # Bail if not (expandable or forced)
      return unless @expandable || force

      # Otherwise we create a new item
      found_item = create_item
    end

    found_item.active = true
    # Safely call pool_spawn callback
    found_item.object.pool_spawn if found_item.object.respond_to? :pool_spawn
    found_item.object
  end

  def despawn(object)
    # Finds the current object
    @item_stack.each do |item|
      next unless item.object == object

      item.active = false
      # Safely call pool_despawn callback
      item.object.pool_despawn if item.object.respond_to? :pool_despawn
      break
    end
  end

  def active_objects
    objs = []

    @item_stack.each do |item|
      objs.push(item.object) if item.active
    end

    objs
  end

  private

  def init_stack
    (1..@pool_size).each do |_i|
      create_item
    end
  end

  # Creates a pool item and push to stack
  def create_item
    object = @spawn_object.call

    object.pool_create if object.respond_to? :pool_create

    item = PoolItem.new(object)

    @item_stack.push(item)

    item
  end
end
