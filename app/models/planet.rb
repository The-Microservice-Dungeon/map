class Planet < ApplicationRecord
  enum planet_type: %i[default spawn spacestation], _default: :default, _suffix: true
  validates :planet_type, inclusion: { in: planet_types.keys }

  attribute :movement_difficulty, :integer, default: 0
  attribute :recharge_multiplicator, :integer, default: 0

  validates :movement_difficulty, numericality: { greater_than_or_equal_to: 0 }
  validates :recharge_multiplicator, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :gameworld

  has_and_belongs_to_many :neighbours,
                          class_name: 'Planet',
                          join_table: 'planets_neighbours',
                          foreign_key: 'planet_id',
                          association_foreign_key: 'neighbour_id'

  has_many :resources

  def add_neighbour(neighbour)
    neighbours << neighbour unless neighbours.include?(neighbour) || neighbour == self
    neighbour.neighbours << self unless neighbour.neighbours.include?(self) || self == neighbour
  end

  def taken!
    self.taken_at = DateTime.current
  end

  def taken?
    !taken_at.nil?
  end

  def as_json(options = {})
    hash = super(options)
    hash.delete('x')
    hash.delete('y')
    hash
  end
end
