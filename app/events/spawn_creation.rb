class SpawnCreation < ApplicationRecord
  belongs_to :planet

  def execute
    planet.planet_type = 'spawn'
    planet.resources.delete
    $producer.produce_async(topic: 'spawn_created', payload: to_json)
  end
end
