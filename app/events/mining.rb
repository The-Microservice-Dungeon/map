class Mining < ApplicationRecord
  belongs_to :planet
  belongs_to :resource
  validates :amount_requested, numericality: { greater_than_or_equal_to: 0 }, presence: true

  after_save :publish_mining_events

  def execute
    self.amount_requested = [amount_requested, 0].max
    diff = resource.current_amount - amount_requested
    self.amount_mined = [amount_requested, (amount_requested + diff)].min
    resource.current_amount = [diff, 0].max
  end

  def publish_mining_events
    $producer.produce_async(topic: 'resource_mined', payload: to_json)
    $producer.produce_async(topic: 'resource_emptied', payload: resource.to_json) if resource.current_amount.zero?
  end
end
