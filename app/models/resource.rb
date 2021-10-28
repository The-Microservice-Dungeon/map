class Resource < ApplicationRecord
  belongs_to :planet
  belongs_to :resource_type

  validates :max_amount, numericality: { greater_than: 0 }
  validates :current_amount, numericality: { greater_than_or_equal_to: 0 }

  scope :of_type, ->(resource_type_id) { where(resource_type_id: resource_type_id) }

  def execute_mining(amount_mined)
    amount_mined = [amount_mined, 0].max
    diff = current_amount - amount_mined
    actual_amount_mined = [amount_mined, (amount_mined + diff)].min

    mining = Mining.create!(amount_mined: actual_amount_mined, planet_id: planet_id,
                            resource_type_id: resource_type_id)

    self.current_amount = [diff, 0].max

    mining
    # $producer.publish_async(topic: "resource_mined", payload: mining.to_json)
  end
end
