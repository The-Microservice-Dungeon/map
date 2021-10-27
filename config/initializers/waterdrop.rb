$producer = WaterDrop::Producer.new

$producer.setup do |config|
  config.deliver = true
  config.kafka = {
    'bootstrap.servers': 'localhost:29092',
    'request.required.acks': 1
  }
end
