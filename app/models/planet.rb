class Planet < ApplicationRecord
  include Filterable

  enum planet_type: %i[default spawn spacestation], _default: :default, _suffix: true
  validates :planet_type, inclusion: { in: planet_types.keys }

  attribute :movement_difficulty, :integer, default: 1
  attribute :recharge_multiplicator, :integer, default: 1

  validates :movement_difficulty, numericality: { greater_than_or_equal_to: 0 }
  validates :recharge_multiplicator, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :gameworld

  has_one :resource, dependent: :delete

  scope :filter_by_planet_type, ->(planet_type) { where planet_type: planet_type }
  scope :filter_by_taken, lambda { |taken|
    where taken_at: nil if taken == 'false'
    where.not taken_at: nil if taken == 'true'
  }

  after_create do
    SpacestationCreation.create(planet_id: id) if planet_type == 'spacestation'
  end

  def add_neighbour(neighbour)
    neighbours << neighbour unless neighbours.include?(neighbour) || neighbour == self
    neighbour.neighbours << self unless neighbour.neighbours.include?(self) || self == neighbour
  end

  def add_resource(resource_type, max_amount)
    self.resource = Resource.create(resource_type: resource_type,
                                    planet_id: id,
                                    max_amount: max_amount,
                                    current_amount: max_amount)
  end

  def taken!
    self.taken_at = Time.now
    save!
  end

  def taken?
    !taken_at.nil?
  end

  def neighbour_ids
    neighbours.pluck(:id)
  end

  def neighbours
    Planet.where(x: (x - 1), y: y)
          .or(Planet.where(x: (x + 1), y: y))
          .or(Planet.where(x: x, y: (y - 1)))
          .or(Planet.where(x: x, y: (y + 1)))
          .where(gameworld_id: gameworld_id, deleted_at: nil)
  end

  def top_neighbour
    Planet.find_by(gameworld_id: gameworld_id, x: (x - 1), y: y, deleted_at: nil)
  end

  def bottom_neighbour
    Planet.find_by(gameworld_id: gameworld_id, x: (x + 1), y: y, deleted_at: nil)
  end

  def left_neighbour
    Planet.find_by(gameworld_id: gameworld_id, x: x, y: (y - 1), deleted_at: nil)
  end

  def right_neighbour
    Planet.find_by(gameworld_id: gameworld_id, x: x, y: (y + 1), deleted_at: nil)
  end

  def inner_map?
    grid_size = gameworld.map_size - 1
    inner = grid_size / 3
    x > inner && x < grid_size - inner && y > inner && y < grid_size - inner
  end

  def mid_map?
    grid_size = gameworld.map_size - 1
    mid = grid_size / 3 / 2
    x > mid && x < grid_size - mid && y > mid && y < grid_size - mid
  end

  def outer_map?
    !inner_map? && !mid_map?
  end
end
