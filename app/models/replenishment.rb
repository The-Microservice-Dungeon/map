class Replenishment < ApplicationRecord
  belongs_to :planet
  belongs_to :resource_type

  validates :amount_replenished, numericality: { greater_than: 0 }
end
