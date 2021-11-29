class CreateGameworldSpacestationsJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  def perform(gameworld_id)
    fetch_gameworld(gameworld_id)
    create_spacestations
  end

  private

  def fetch_gameworld(gameworld_id)
    @gameworld = Gameworld.find(gameworld_id)
    @map_size = @gameworld.map_size
  end

  def create_spacestations
    border = 2

    possible_spacestations = @gameworld.planets.find_all do |p|
      p.x >= border &&
        p.y < @map_size - border   &&
        p.x < @map_size - border   &&
        p.y >= border &&
        p.deleted_at.nil?
    end

    possible_spacestations.sample(@map_size).each do |p|
      p.planet_type = 'spacestation'
      p.recharge_multiplicator = 2
      p.save!
    end
  end
end
