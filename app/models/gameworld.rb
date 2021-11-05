class Gameworld < ApplicationRecord
  enum status: %i[active inactive], _default: :active
  validates :status, inclusion: { in: statuses.keys }

  has_many :planets, dependent: :destroy

  after_save :set_other_gameworlds_to_inactive
  after_save :trigger_gameworld_created_event

  def trigger_gameworld_created_event
    $producer.produce_async(topic: 'gameworld_created', payload: { gameworld_id: id }.to_json)
  end

  def set_other_gameworlds_to_inactive
    Gameworld.where(status: 'active').each do |gameworld|
      gameworld.status == 'inactive' unless gameworld.id == id
    end
  end
end
