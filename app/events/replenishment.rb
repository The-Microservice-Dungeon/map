class Replenishment < ApplicationRecord
  belongs_to :planet
  belongs_to :resource

  before_save :increase_version
  after_save :publish_replenishment_events

  def increase_version
    result = ActiveRecord::Base.connection.execute("SELECT nextval('replenishments_version_seq')")
    self.version = result[0]['nextval']
  end

  def execute_replenishment
    self.amount_replenished = resource.max_amount - resource.current_amount
    resource.current_amount = resource.max_amount
  end

  def publish_replenishment_events
    $producer.produce_async topic: 'map',
                            headers: resource_replenished_headers,
                            payload: resource_replenished_payload.to_json
  end

  def resource_replenished_headers
    {
      'eventId' => id,
      'transactionId' => transaction_id.to_s,
      'version' => version.to_s,
      'timestamp' => created_at.iso8601,
      'type' => 'resource-replenished'
    }
  end

  def resource_replenished_payload
    {
      id: resource_id,
      resource_type: resource.resource_type.name
    }
  end
end
