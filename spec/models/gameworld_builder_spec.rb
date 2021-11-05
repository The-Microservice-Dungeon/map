require 'rails_helper'

RSpec.describe GameworldBuilder, type: :model do
  context 'initializing the gameworld builder' do
    it 'builds a new gameworld with associated planets' do
      gwb = GameworldBuilder.new(1, 10)
      gameworld = gwb.gameworld

      expect(gameworld.status).to eq('active')
      expect(gameworld.planets.first.x).to eq(0)
      expect(gameworld.planets.first.y).to eq(0)
    end

    it 'builds the planet size dependent on parameters given' do
      gwb = GameworldBuilder.new(10, 20)
      planets = gwb.gameworld.planets

      expect(planets.length).to eq(400)
    end
  end

  context 'neighbour the gameworlds planets' do
    it 'planet at x:0, y:0 should have 2 neighbours' do
      gwb = GameworldBuilder.new(1, 10)
      gwb.neighbour_planets

      planets = gwb.gameworld.planets

      planet = planets.find { |p| p.x == 0 && p.y == 0 }

      expect(planet.neighbours.length).to eq(2)

      expect(planet.neighbours.first.x).to eq(1)
      expect(planets.first.neighbours.first.y).to eq(0)

      expect(planet.neighbours.last.x).to eq(0)
      expect(planet.neighbours.last.y).to eq(1)
    end

    it 'planet at x:5, y:5 should have 4 neighbours' do
      gwb = GameworldBuilder.new(5, 10)
      gwb.neighbour_planets

      planets = gwb.gameworld.planets
      planet = planets.find { |p| p.x == 5 && p.y == 5 }
      neighbours = planets.select do |p|
        p.x == 6 && p.y == 5 ||
          p.x == 4 && p.y == 5 ||
          p.x == 5 && p.y == 6 ||
          p.x == 5 && p.y == 4
      end

      expect(planet.neighbours.length).to eq(4)
      expect(planet.neighbours).to match_array(neighbours)
    end
  end

  context 'database persistence' do
    it 'saves the gameworld to the database' do
      gwb = GameworldBuilder.new(30, 20)
      gwb.gameworld.save
      gwb.neighbour_planets

      gameworld = Gameworld.all.first

      expect(gameworld.planets.length).to eq(400)
      expect(gameworld.planets.first.neighbours.length).to eq(2)
    end
  end

  context 'spawn creation' do
    it 'recharge faster if on spawn' do
      gwb = GameworldBuilder.new(12, 20)
      gwb.create_spawns

      energy_count = gwb.gameworld.planets.count { |p| p.recharge_multiplicator == 2 }

      expect(energy_count).to eq(12)
    end
  end

  context 'spawn creation' do
    it 'creates as many spawns as there are players' do
      gwb = GameworldBuilder.new(12, 20)
      gwb.create_spawns
      gwb2 = GameworldBuilder.new(35, 10)
      gwb2.create_spawns
      gwb3 = GameworldBuilder.new(2, 20)
      gwb3.create_spawns

      spawn_count = gwb.gameworld.planets.count { |p| p.planet_type == 'spawn' }
      spawn_count2 = gwb2.gameworld.planets.count { |p| p.planet_type == 'spawn' }
      spawn_count3 = gwb3.gameworld.planets.count { |p| p.planet_type == 'spawn' }

      expect(spawn_count).to eq(12)
      expect(spawn_count2).to eq(35)
      expect(spawn_count3).to eq(2)
    end
  end

  context 'spacestation creation' do
    it 'creates spacestations in all tiles within boundaries' do
      gwb = GameworldBuilder.new(12, 10)
      gwb.create_spacestations

      spacestation_count = gwb.gameworld.planets.count { |p| p.planet_type == 'spacestation' }

      expect(spacestation_count).to eq(4)
    end
  end

  context 'resouces created' do
    it 'creates appropriate amount of resources' do
      coal = create(:resource_type, name: 'coal')
      iron = create(:resource_type, name: 'iron')
      gem = create(:resource_type, name: 'gem')
      gold = create(:resource_type, name: 'gold')
      platin = create(:resource_type, name: 'platin')

      gwb = GameworldBuilder.new(12, 20)
      gwb.create_spawns
      gwb.create_spacestations
      gwb.create_resources

      coal_count = gwb.gameworld.planets.count { |p| p.resources.any? { |r| r.resource_type_id == coal.id } }
      iron_count = gwb.gameworld.planets.count { |p| p.resources.any? { |r| r.resource_type_id == iron.id } }
      gem_count = gwb.gameworld.planets.count { |p| p.resources.any? { |r| r.resource_type_id == gem.id } }
      gold_count = gwb.gameworld.planets.count { |p| p.resources.any? { |r| r.resource_type_id == gold.id } }
      platin_count = gwb.gameworld.planets.count { |p| p.resources.any? { |r| r.resource_type_id == platin.id } }

      expect(coal_count).to eq(40)
      expect(iron_count).to eq(20)
      expect(gem_count).to eq(13)
      expect(gold_count).to eq(10)
      expect(platin_count).to eq(8)
    end

    it 'doesn´t place resources on Spawns or Space Stations' do
      create(:resource_type, name: 'coal')
      create(:resource_type, name: 'iron')
      create(:resource_type, name: 'gem')
      create(:resource_type, name: 'gold')
      create(:resource_type, name: 'platin')

      gwb = GameworldBuilder.new(12, 20)
      gwb.create_spawns
      gwb.create_spacestations
      gwb.create_resources

      spawns = gwb.gameworld.planets.find_all { |p| p.planet_type == 'spawn' && p.resources.empty? }.count
      spacestations = gwb.gameworld.planets.find_all do |p|
        p.planet_type == 'spacestation' && p.resources.empty?
      end.count

      expect(spawns).to eq(12)
      expect(spacestations).to eq(30)
    end
  end
end
