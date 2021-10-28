class Mining < ApplicationRecord
  belongs_to :planet
  belongs_to :resource_type
  validates :amount_mined, numericality: { greater_than_or_equal_to: 0 }
end
