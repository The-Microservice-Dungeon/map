class Planet < ApplicationRecord
  enum planet_type: %i[default spawn spacestation], _default: :default, _suffix: true
  validates :planet_type, inclusion: { in: planet_types.keys }

  attribute :movement_difficulty, :integer, default: 1
  attribute :recharge_multiplicator, :integer, default: 1

  validates :movement_difficulty, numericality: { greater_than_or_equal_to: 0 }
  validates :recharge_multiplicator, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :gameworld

  has_and_belongs_to_many :neighbours,
                          class_name: 'Planet',
                          join_table: 'planets_neighbours',
                          foreign_key: 'planet_id',
                          association_foreign_key: 'neighbour_id'

  has_one :resource, dependent: :delete

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
    self.taken_at = DateTime.current
  end

  def taken?
    !taken_at.nil?
  end
end
