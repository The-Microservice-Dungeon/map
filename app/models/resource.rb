class Resource < ApplicationRecord
  belongs_to :planet
  belongs_to :resource_type

  validates :max_amount, numericality: { greater_than: 0 }
  validates :current_amount, numericality: { greater_than_or_equal_to: 0 }
end
