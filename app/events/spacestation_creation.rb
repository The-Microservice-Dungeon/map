class SpacestationCreation < ApplicationRecord
  belongs_to :planet

  before_save :increase_version
  after_save :publish_speacestation_creation_events

  def increase_version
    result = ActiveRecord::Base.connection.execute("SELECT nextval('spacestation_creations_version_seq')")
    self.version = result[0]['nextval']
  end

  def execute
    planet.planet_type = 'spacestation'
    planet.resources.delete
    planet.save!
  end

  def publish_speacestation_creation_events
    $producer.produce_async topic: 'map',
                            headers: spacestation_created_headers,
                            payload: spacestation_created_payload.to_json
  end

  def spacestation_created_headers
    {
      'eventId' => id,
      'transactionId' => transaction_id.to_s,
      'version' => version.to_s,
      'timestamp' => created_at.iso8601,
      'type' => 'spacestation-created'
    }
  end

  def spacestation_created_payload
    {
      id: planet_id
    }
  end
end
