class Gameworld < ApplicationRecord
  enum status: %i[active inactive], _default: :active
  validates :status, inclusion: { in: statuses.keys }

  has_many :planets, dependent: :destroy

  def as_json(options = {})
    hash = super(options)
    planets = hash['planets']
    planets.each do |p|
      p.delete('x')
      p.delete('y')
    end

    hash['planets'] = planets
    hash
  end
end
