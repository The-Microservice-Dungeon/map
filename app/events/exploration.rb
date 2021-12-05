class Exploration < ApplicationRecord
  belongs_to :planet

  before_save :increase_version
  after_save :publish_planet_explored_event

  def increase_version
    result = ActiveRecord::Base.connection.execute("SELECT nextval('explorations_version_seq')")
    self.version = result[0]['nextval']
  end

  def publish_planet_explored_event
    Kafka::Message.publish(headers, payload)
  end

  def headers
    {
      'eventId' => id,
      'transactionId' => transaction_id.to_s,
      'version' => version.to_s,
      'timestamp' => created_at.iso8601,
      'type' => 'planet-explored'
    }
  end

  def payload
    {
      planet: {
        resource_id: planet.resource&.id,
        neighbour_ids: planet.neighbours.pluck(:id),
        recharge_multiplicator: planet.recharge_multiplicator,
        movement_difficulty: planet.movement_difficulty,
        planet_type: planet.planet_type
      }
    }
  end
end
