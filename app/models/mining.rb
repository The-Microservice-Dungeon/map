class Mining < ApplicationRecord
  belongs_to :planet
  belongs_to :resource_type
  validates :amount_mined, numericality: { greater_than: 0 }
end
