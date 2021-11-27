class Resource < ApplicationRecord
  belongs_to :planet
  enum resource_type: %i[coal iron gem gold platin], _default: :coal, _suffix: true

  validates :max_amount, numericality: { greater_than: 0 }
  validates :current_amount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: :max_amount }

  scope :of_type, ->(resource_type) { where(resource_type: resource_type) }
end
