class SpawnCreation < ApplicationRecord
  belongs_to :planet

  after_save :publish_spawn_creation_evenets

  def execute
    planet.planet_type = 'spawn'
    planet.resources.delete
  end

  def publish_spawn_creation_evenets
    $producer.produce_async(topic: 'spawn_created', payload: to_json)
  end
end
