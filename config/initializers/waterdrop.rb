Rails.logger = Logger.new(STDOUT)

$producer = WaterDrop::Producer.new

$producer.setup do |config|
  config.deliver = true
  config.kafka = {
    'bootstrap.servers': 'localhost:29092',
    'request.required.acks': 1
  }
end

$producer.monitor.subscribe('message.produced_async') do |event|
  Rails.logger.debug "A message: '#{event[:message][:payload]} was produced to topic: '#{event[:message][:topic]}'!"
end
