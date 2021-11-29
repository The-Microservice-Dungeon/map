class CreateGameworldDeletePlanetsJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  def perform(gameworld_id)
    fetch_gameworld(gameworld_id)
    delete_random_planets
  end

  private

  def fetch_gameworld(gameworld_id)
    @gameworld = Gameworld.find(gameworld_id)
  end

  def delete_random_planets
    map_size = @gameworld.map_size
    count_to_delete = @gameworld.planets.size.fdiv(10).ceil * rand(1..3).ceil
    deletable_planets = @gameworld.planets.select do |p|
      p.planet_type == 'default' && !p.inner_map? && p.x != 1 && p.y != 1 && p.x != map_size - 2 && p.y != map_size - 2
    end.sample(count_to_delete)

    deletable_planets.each do |p|
      p.deleted_at = Time.now
      p.save!
    end
  end
end
