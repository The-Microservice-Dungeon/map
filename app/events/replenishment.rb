class Replenishment < ApplicationRecord
  belongs_to :planet
  belongs_to :resource

  def execute_replenishment
    self.amount_replenished = resource.max_amount - resource.current_amount
    resource.current_amount = resource.max_amount
    $producer.produce_async(topic: 'resource_replenished', payload: to_json)
  end
end
