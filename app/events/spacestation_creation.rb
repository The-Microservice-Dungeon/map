class SpacestationCreation < ApplicationRecord
  belongs_to :planet

  def execute
    planet.planet_type = 'spacestation'
    $producer.produce_async(topic: 'spacestation_creation', payload: to_json)
  end
end
