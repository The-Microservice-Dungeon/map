# frozen_string_literal: true

##
# MapStatus
#
# @see https://the-microservice-dungeon.github.io/docs/openapi/map/#tag/status
class MapStatus < ApplicationRecord
  def self.map_status
    map_status = create_with(last_request_time: Time.now)
    map_status.find_or_create_by(id: '89d6a303-a0b0-40b4-95f9-b2e1c0c90781')
  end

  def online
    true
  end

  def version
    Rails.application.config.version
  end
end
