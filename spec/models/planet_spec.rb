require 'rails_helper'

RSpec.describe Planet, type: :model do
  it 'creates a new planet' do
    planet = create(:planet)

    expect(planet.planet_type).to eq('default')
  end

  it 'finds the planet by location' do
    gameworld = create(:gameworld)
    planet = create(:planet, gameworld: gameworld, x: 0, y: 0)
    neighbour = create(:planet, gameworld: gameworld, x: 1, y: 0)

    expect(planet.neighbours).to eq([neighbour])
    expect(neighbour.neighbours).to eq([planet])
  end

  it 'sets the planet_type to spawn' do
    planet = create(:planet)
    planet.spawn_planet_type!

    expect(planet.planet_type).to eq('spawn')
  end
end
