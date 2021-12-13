# frozen_string_literal: true

##
# Resource
#
# @see https://github.com/The-Microservice-Dungeon/map/wiki/Domain-Model#resources
# @see https://the-microservice-dungeon.github.io/docs/openapi/map/#tag/resources
class Resource < ApplicationRecord
  enum resource_type: %i[coal iron gem gold platin], _suffix: true
  validates :resource_type, inclusion: { in: resource_types.keys }

  belongs_to :planet

  validates :max_amount, numericality: { greater_than: 0 }
  validates :current_amount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: :max_amount }

  scope :of_type, ->(resource_type) { where(resource_type: resource_type) }
end
