class Resource < ApplicationRecord
  belongs_to :planet
  belongs_to :resource_type

  validates :max_amount, numericality: { greater_than: 0 }
  validates :current_amount, numericality: { greater_than_or_equal_to: 0 }

  scope :of_type, ->(resource_type_id) { where(resource_type_id: resource_type_id) }

  def execute_mining(amount_mined)
    diff = current_amount - amount_mined
    actual_amount_mined = diff >= 0 ? amount_mined : (amount_mined + diff)

    mining = Mining.create!(amount_mined: actual_amount_mined, planet_id: planet_id,
                            resource_type_id: resource_type_id)
    self.current_amount = diff >= 0 ? diff : 0

    # $producer.publish_async(topic: "resource_mined", payload: mining.to_json)
    mining
  end
end
