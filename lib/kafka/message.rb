module Kafka
  class Message
    def self.publish(headers, payload)
      producer.produce_async topic: 'map',
                             headers: headers,
                             payload: payload.to_json

      producer.close
    end

    def self.producer
      WaterDrop::Producer.new do |config|
        config.deliver = ENV['RAILS_ENV'] != 'test'
        config.kafka = {
          'bootstrap.servers': ENV.fetch('KAFKA_BOOTSTRAP_ADDRESS', 'localhost:29092'),
          'queue.buffering.max.ms' => 10_000
        }
      end
    end
  end
end