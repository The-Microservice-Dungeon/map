class Planet < ApplicationRecord
  enum planet_type: %i[default spawn spacestation], _default: :default, _suffix: true
  validates :planet_type, inclusion: { in: planet_types.keys }

  belongs_to :gameworld

  has_and_belongs_to_many :neighbours,
                          class_name: 'Planet',
                          join_table: 'planets_neighbours',
                          foreign_key: 'planet_id',
                          association_foreign_key: 'neighbour_id'

  def add_neighbour(neighbour)
    neighbours << neighbour unless neighbours.include?(neighbour) || neighbour == self
    neighbour.neighbours << self unless neighbour.neighbours.include?(self) || self == neighbour
  end
end
