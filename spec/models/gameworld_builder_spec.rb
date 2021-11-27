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
      map_size = 20

      gwb = GameworldBuilder.new(12, map_size)
      gwb.create_spawns
      gwb.create_spacestations
      gwb.create_resources

      coal_count = gwb.gameworld.planets.count { |p| p.resources.any? { |r| r.resource_type == 'coal' } }
      iron_count = gwb.gameworld.planets.count { |p| p.resources.any? { |r| r.resource_type == 'iron' } }
      gem_count = gwb.gameworld.planets.count { |p| p.resources.any? { |r| r.resource_type == 'gem' } }
      gold_count = gwb.gameworld.planets.count { |p| p.resources.any? { |r| r.resource_type == 'gold' } }
      platin_count = gwb.gameworld.planets.count { |p| p.resources.any? { |r| r.resource_type == 'platin' } }

      expect(coal_count).to eq((map_size * map_size) / 20)
      expect(iron_count).to eq((map_size * map_size) / 30)
      expect(gem_count).to eq((map_size * map_size) / 40)
      expect(gold_count).to eq((map_size * map_size) / 50)
      expect(platin_count).to eq((map_size * map_size) / 60)
    end

    it 'doesn´t place resources on Spawns or Space Stations' do
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

  context 'planets removed' do
    it 'enough resources after planet deletion' do
      map_size = 20

      gwb = GameworldBuilder.create_regular_gameworld(12, map_size, 1000)

      existing_planets = gwb.gameworld.planets.find_all { |p| p.deleted_at.nil? }

      coal_count = existing_planets.count { |p| p.resources.any? { |r| r.resource_type == 'coal' } }
      iron_count = existing_planets.count { |p| p.resources.any? { |r| r.resource_type == 'iron' } }
      gem_count = existing_planets.count { |p| p.resources.any? { |r| r.resource_type == 'gem' } }
      gold_count = existing_planets.count { |p| p.resources.any? { |r| r.resource_type == 'gold' } }
      platin_count = existing_planets.count { |p| p.resources.any? { |r| r.resource_type == 'platin' } }

      expect(coal_count).to eq((map_size * map_size) / 20)
      expect(iron_count).to eq((map_size * map_size) / 30)
      expect(gem_count).to eq((map_size * map_size) / 40)
      expect(gold_count).to eq((map_size * map_size) / 50)
      expect(platin_count).to eq((map_size * map_size) / 60)
    end

    it 'correct amount of spawns and spacestations' do
      gwb = GameworldBuilder.create_regular_gameworld(12, 20, 1000)

      existing_planets = gwb.gameworld.planets.find_all { |p| p.deleted_at.nil? }

      spawn_count = existing_planets.count { |p| p.planet_type == 'spawn' }
      spacestation_count = existing_planets.count { |p| p.planet_type == 'spacestation' }

      expect(spawn_count).to eq(12)
      expect(spacestation_count).to eq(30)
    end
  end
end
