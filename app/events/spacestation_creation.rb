class SpacestationCreation < ApplicationRecord
  belongs_to :planet

  after_save :publish_speacestation_creation_events
  def execute
    planet.planet_type = 'spacestation'
    planet.resources.delete
  end

  def publish_speacestation_creation_events
    $producer.produce_async(topic: 'spacestation_creation', payload: to_json)
  end
end
