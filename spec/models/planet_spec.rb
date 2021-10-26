require 'rails_helper'

RSpec.describe Planet, type: :model do
  it 'creates a new planet' do
    planet = create(:planet)

    expect(planet.planet_type).to eq('default')
  end

  it 'adds a neighbouring planet' do
    planet = create(:planet)
    neighbour = create(:planet)

    planet.add_neighbour(neighbour)

    expect(planet.neighbours).to eq([neighbour])
    expect(neighbour.neighbours).to eq([planet])
  end

  it 'sets the planet_type to spawn' do
    planet = create(:planet)
    planet.spawn_planet_type!

    expect(planet.planet_type).to eq('spawn')
  end
end
