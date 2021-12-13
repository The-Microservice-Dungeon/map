# frozen_string_literal: true

class PlanetResourceUniqueness < ActiveRecord::Migration[6.1]
  def change
    add_index :resources, %i[planet_id resource_type], unique: true
  end
end
