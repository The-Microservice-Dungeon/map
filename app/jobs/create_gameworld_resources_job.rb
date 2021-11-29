class CreateGameworldResourcesJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  def perform(gameworld_id)
    fetch_gameworld(gameworld_id)
  end

  private

  def fetch_gameworld(gameworld_id)
    @gameworld = Gameworld.find(gameworld_id)
    create_resources
  end

  def create_resources
    resources = [
      { patch_amount: @gameworld.planets.size / 20, name: 'coal', part_of_map: :outer_map? },
      { patch_amount: @gameworld.planets.size / 30, name: 'iron', part_of_map: :mid_map? },
      { patch_amount: @gameworld.planets.size / 40, name: 'gem', part_of_map: :mid_map? },
      { patch_amount: @gameworld.planets.size / 50, name: 'gold', part_of_map: :inner_map? },
      { patch_amount: @gameworld.planets.size / 60, name: 'platin', part_of_map: :inner_map? }
    ]

    resources.each do |r|
      create_specific_resources(r[:name], r[:patch_amount], r[:part_of_map])
    end
  end

  def create_specific_resources(name, patch_amount, part_of_map)
    existing_planets = @gameworld.planets.find_all { |p| p.deleted_at.nil? }
    resource_planets = existing_planets.select do |p|
      p.method(part_of_map).call && p.planet_type == 'default' && p.resource.nil?
    end.sample(patch_amount)

    resource_planets.each do |p|
      p.add_resource(name, 10_000)
    end
  end
end
