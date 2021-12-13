# frozen_string_literal: true

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
    planet.resource.delete
    planet.save!
  end

  def publish_speacestation_creation_events
    Kafka::Message.publish(spacestation_created_headers, spacestation_created_payload)
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
      planet_id: planet_id
    }
  end
end
