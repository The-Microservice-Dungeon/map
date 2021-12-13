# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameworldBuilder, type: :model do
  context 'initializing the gameworld builder' do
    let(:gameworld) { create(:gameworld) }

    it 'builds a new gameworld with associated planets' do
      gwb = GameworldBuilder.new(gameworld, 1, 10)
      gwb.init_planets
      gameworld = gwb.gameworld

      expect(gameworld.status).to eq('inactive')
      expect(gameworld.planets.count).to eq(100)
      expect(Planet.find_by(x: 0, y: 0)).to be_truthy
    end

    it 'builds the planet size dependent on parameters given' do
      gwb = GameworldBuilder.new(gameworld, 10, 20)
      gwb.init_planets
      expect(gameworld.planets.count).to eq(400)
    end
  end

  context 'database persistence' do
    let(:gameworld) { create(:gameworld) }

    it 'saves the gameworld to the database' do
      gwb = GameworldBuilder.new(gameworld, 30, 20)
      gwb.init_planets
      gameworld = Gameworld.all.first
      expect(gameworld.planets.length).to eq(400)
      expect(gameworld.planets.first.neighbours.length).to eq(2)
    end
  end

  context 'spacestation creation' do
    let(:gameworld) { create(:gameworld) }

    it 'creates spacestations in all tiles within boundaries' do
      gwb = GameworldBuilder.new(gameworld, 12, 10)
      gwb.init_planets

      spacestation_count = gwb.gameworld.planets.count { |p| p.planet_type == 'spacestation' }

      expect(spacestation_count).to eq(24)
    end
  end

  context 'resouces created' do
    let(:gameworld) { create(:gameworld) }

    it 'creates appropriate amount of resources' do
      map_size = 20

      gwb = GameworldBuilder.new(gameworld, 12, map_size)
      gwb.init_planets
      CreateGameworldResourcesJob.new.perform(gameworld.id)

      coal_count = gwb.gameworld.planets.count { |p| p.resource&.resource_type == 'coal' }
      iron_count = gwb.gameworld.planets.count { |p| p.resource&.resource_type == 'iron' }
      gem_count = gwb.gameworld.planets.count { |p| p.resource&.resource_type == 'gem' }
      gold_count = gwb.gameworld.planets.count { |p| p.resource&.resource_type == 'gold' }
      platin_count = gwb.gameworld.planets.count { |p| p.resource&.resource_type == 'platin' }

      expect(coal_count).to eq((map_size * map_size) / 20)
      expect(iron_count).to eq((map_size * map_size) / 30)
      expect(gem_count).to eq((map_size * map_size) / 40)
      expect(gold_count).to eq((map_size * map_size) / 50)
      expect(platin_count).to eq((map_size * map_size) / 60)
    end

    it 'doesn´t place resources on Spawns or Space Stations' do
      gwb = GameworldBuilder.new(gameworld, 12, 20)
      gwb.init_planets
      CreateGameworldResourcesJob.new.perform(gameworld.id)

      gwb.gameworld.reload

      spacestations = gwb.gameworld.planets.find_all do |p|
        p.planet_type == 'spacestation' && p.resource.nil?
      end.count

      expect(spacestations).to eq(24)
    end
  end

  context 'planets removed' do
    let(:gameworld) { create(:gameworld) }
    it 'enough resources after planet deletion' do
      map_size = 20
      gwb = GameworldBuilder.create_regular_gameworld(gameworld, 12)
      CreateGameworldResourcesJob.new.perform(gwb.gameworld.id)

      existing_planets = gwb.gameworld.planets.find_all { |p| p.deleted_at.nil? }

      coal_count = existing_planets.count { |p| p.resource&.resource_type == 'coal' }
      iron_count = existing_planets.count { |p| p.resource&.resource_type == 'iron' }
      gem_count = existing_planets.count { |p| p.resource&.resource_type == 'gem' }
      gold_count = existing_planets.count { |p| p.resource&.resource_type == 'gold' }
      platin_count = existing_planets.count { |p| p.resource&.resource_type == 'platin' }

      expect(coal_count).to eq((map_size * map_size) / 20)
      expect(iron_count).to eq((map_size * map_size) / 30)
      expect(gem_count).to eq((map_size * map_size) / 40)
      expect(gold_count).to eq((map_size * map_size) / 50)
      expect(platin_count).to eq((map_size * map_size) / 60)
    end

    it 'correct amount of spawns and spacestations' do
      gwb = GameworldBuilder.create_regular_gameworld(gameworld, 12)
      gwb.gameworld.reload

      existing_planets = gwb.gameworld.planets.find_all { |p| p.deleted_at.nil? }

      spacestation_count = existing_planets.count { |p| p.planet_type == 'spacestation' }

      expect(spacestation_count).to eq(24)
    end
  end
end
