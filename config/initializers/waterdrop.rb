$producer = WaterDrop::Producer.new

$producer.setup do |config|
  config.deliver = true
  config.kafka = {
    'bootstrap.servers': ENV.fetch('KAFKA_BOOTSTRAP_ADDRESS', 'localhost:29092'),
    'request.required.acks': 1
  }
end
