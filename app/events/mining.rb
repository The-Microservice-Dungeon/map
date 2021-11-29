class Mining < ApplicationRecord
  belongs_to :planet
  belongs_to :resource
  validates :amount_requested, numericality: { greater_than_or_equal_to: 0 }, presence: true

  before_save :increase_version
  after_save :publish_mining_events

  def increase_version
    result = ActiveRecord::Base.connection.execute("SELECT nextval('minings_version_seq')")
    self.version = result[0]['nextval']
  end

  def execute
    self.amount_requested = [amount_requested, 0].max
    diff = resource.current_amount - amount_requested
    self.amount_mined = [amount_requested, (amount_requested + diff)].min
    resource.current_amount = [diff, 0].max
    resource.save!
  end

  def publish_mining_events
    $producer.produce_async topic: 'map',
                            headers: resource_mined_headers,
                            payload: resource_mined_payload.to_json
  end

  def resource_mined_headers
    {
      'eventId' => id,
      'transactionId' => transaction_id.to_s,
      'version' => version.to_s,
      'timestamp' => created_at.iso8601,
      'type' => 'resource-mined'
    }
  end

  def resource_mined_payload
    {
      planet_id: planet_id,
      resource_id: resource_id,
      resource_type: resource.resource_type,
      amount_mined: amount_mined,
      amount_left: resource.current_amount
    }
  end
end
