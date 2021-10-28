class Replenishment < ApplicationRecord
  belongs_to :planet
  belongs_to :resource_type
end
