class Exploration < ApplicationRecord
  belongs_to :planet

  after_save :publish_planet_explored_event

  def publish_planet_explored_event
    $producer.produce_async(topic: 'planet_explored', payload: payload.to_json)
  end

  def payload
    {
      transaction_id: transaction_id,
      planet: {
        id: planet.id,
        resources: planet.resources,
        neighbour_ids: planet.neighbours.pluck(:id),
        recharge_multiplicator: planet.recharge_multiplicator,
        movement_difficulty: planet.movement_difficulty,
        planet_type: planet.planet_type
      }
    }
  end
end
