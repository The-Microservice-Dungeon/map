# frozen_string_literal: true

##
# Gameworld
#
# @see https://github.com/The-Microservice-Dungeon/map/wiki/Domain-Model#gameworlds
# @see https://the-microservice-dungeon.github.io/docs/openapi/map/#tag/gameworlds
class Gameworld < ApplicationRecord
  enum status: %i[active inactive], _default: :inactive
  validates :status, inclusion: { in: statuses.keys }

  has_many :planets, dependent: :destroy

  ##
  # Sets the gameworld's status to `'active'` while setting all other gameworlds
  # statuses to `'inactive'`.
  def activate
    Gameworld.update_all(status: 'inactive')
    update(status: 'active')
  end

  ##
  # Returns the `spacestaion_ids` for the gameworld.
  # @return [Array<UUID>]
  def spacestation_ids
    Planet.where(gameworld_id: id, planet_type: 'spacestation').pluck(:id)
  end

  ##
  # Publishes the `'gameworld-created'` event under the `"map"` topic.
  # @see lib/kafka/message.rb
  def publish_gameworld_created_event
    Kafka::Message.publish(gameworld_created_headers, gameworld_created_payload)
  end

  ##
  # Returns the payload for the `'gameworld-created'` event.
  # @return [Hash<Symbol, String>]
  def gameworld_created_payload
    {
      id: id,
      spacestation_ids: spacestation_ids,
      status: status
    }
  end

  ##
  # Returns the headers for the `'gameworld-created'` event.
  # @return [Hash<String, String>]
  def gameworld_created_headers
    {
      'eventId' => SecureRandom.uuid,
      'transactionId' => nil.to_s,
      'version' => Gameworld.count.to_s,
      'timestamp' => updated_at.iso8601,
      'type' => 'gameworld-created'
    }
  end
end
