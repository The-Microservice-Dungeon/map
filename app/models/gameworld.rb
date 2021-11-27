class Gameworld < ApplicationRecord
  enum status: %i[active inactive], _default: :active
  validates :status, inclusion: { in: statuses.keys }

  has_many :planets, dependent: :destroy

  after_create :set_other_gameworlds_to_inactive
  after_create :publish_gameworld_created_event

  def set_other_gameworlds_to_inactive
    Gameworld.where(status: 'active').each do |gameworld|
      gameworld.status = 'inactive' unless gameworld.id == id
      gameworld.save!
    end
  end

  def publish_gameworld_created_event
    $producer.produce_async topic: 'map',
                            headers: gameworld_created_headers,
                            payload: gameworld_created_payload.to_json
  end

  def gameworld_created_headers
    {
      'eventId' => id,
      'transactionId' => nil.to_s,
      'version' => nil.to_s,
      'timestamp' => created_at.iso8601,
      'type' => 'gameworld_created'
    }
  end

  def gameworld_created_payload
    {
      gameworld_id: id
    }
  end
end
