# frozen_string_literal: true

class PlanetXYIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :planets, %i[gameworld_id x y]
  end
end
