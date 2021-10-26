require 'rails_helper'

RSpec.describe Planet, type: :model do
  it 'creates a new planet' do
    gameworld = Gameworld.new
    gameworld.save

    planet = Planet.new(gameworld_id: gameworld.id)
    planet.save

    expect(planet.planet_type).to eq('default')
  end

  it 'adds a neighbouring planet' do
    gameworld = Gameworld.new
    gameworld.save

    planet = Planet.new(gameworld_id: gameworld.id)
    planet.save

    neighbour = Planet.new(gameworld_id: gameworld.id)
    neighbour.save

    planet.add_neighbour(neighbour)

    expect(planet.neighbours).to eq([neighbour])
    expect(neighbour.neighbours).to eq([planet])
  end
end
