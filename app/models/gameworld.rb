class Gameworld < ApplicationRecord
  enum status: %i[active inactive], _default: :inactive
  validates :status, inclusion: { in: statuses.keys }

  has_many :planets, dependent: :destroy

  def activate
    Gameworld.update_all(status: 'inactive')
    update(status: 'active')
  end

  def publish_gameworld_created_event
    $producer.produce_async topic: 'map',
                            headers: gameworld_created_headers,
                            payload: gameworld_created_payload.to_json
  end

  def gameworld_created_headers
    {
      'eventId' => SecureRandom.uuid,
      'transactionId' => nil.to_s,
      'version' => nil.to_s,
      'timestamp' => updated_at.iso8601,
      'type' => 'gameworld-created'
    }
  end

  def gameworld_created_payload
    {
      gameworld_id: id
    }
  end
end
