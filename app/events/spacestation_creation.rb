class SpacestationCreation < ApplicationRecord
  belongs_to :planet

  def execute
    planet.planet_type = 'spacestation'
    planet.resources.delete
    $producer.produce_async(topic: 'spacestation_creation', payload: to_json)
  end
end
