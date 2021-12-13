# frozen_string_literal: true

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
    existing_planets = @gameworld
                       .planets.left_joins(:resource)
                       .where(deleted_at: nil,
                              planet_type: 'default',
                              resource: { planet_id: nil })
    resource_planets = existing_planets.select do |p|
      p.method(part_of_map).call
    end

    resources = resource_planets.sample(patch_amount).map do |p|
      { id: SecureRandom.uuid,
        planet_id: p.id,
        resource_type: name,
        max_amount: 10_000,
        current_amount: 10_000,
        created_at: Time.now,
        updated_at: Time.now }
    end

    Resource.insert_all(resources)
  end
end
