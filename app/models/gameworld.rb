class Gameworld < ApplicationRecord
  enum status: %i[active inactive], _default: :inactive
  validates :status, inclusion: { in: statuses.keys }

  has_many :planets, dependent: :destroy

  after_create :publish_gameworld_created_event

  def activate
    Gameworld.update_all(status: 'inactive')
    update(status: 'active')
  end

  def publish_gameworld_created_event
    $producer.produce_async topic: 'map',
                            headers: gameworld_created_headers,
                            payload: to_json
  end

  def gameworld_created_headers
    {
      'eventId' => SecureRandom.uuid,
      'transactionId' => nil.to_s,
      'version' => Gameworld.count.to_s,
      'timestamp' => updated_at.iso8601,
      'type' => 'gameworld-created'
    }
  end

  def spacestation_ids
    Planet.where(gameworld_id: id, planet_type: 'spacestation').pluck(:id)
  end
end
