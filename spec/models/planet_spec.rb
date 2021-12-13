# frozen_string_literal: true

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

  describe 'neighbour direction' do
    let(:gameworld) { create(:gameworld) }
    let(:planet) { create(:planet, gameworld: gameworld, x: 0, y: 0) }

    it 'returns the neighbours direction as "west"' do
      neighbour = create(:planet, gameworld: gameworld, x: 1, y: 0)
      expect(planet.direction_from_neighbour(neighbour)).to eq('west')
    end

    it 'returns the neighbours direction as "east"' do
      neighbour = create(:planet, gameworld: gameworld, x: -1, y: 0)
      expect(planet.direction_from_neighbour(neighbour)).to eq('east')
    end

    it 'returns the neighbours direction as "north"' do
      neighbour = create(:planet, gameworld: gameworld, x: 0, y: 1)
      expect(planet.direction_from_neighbour(neighbour)).to eq('north')
    end

    it 'returns the neighbours direction as "south"' do
      neighbour = create(:planet, gameworld: gameworld, x: 0, y: -1)
      expect(planet.direction_from_neighbour(neighbour)).to eq('south')
    end
  end
end
