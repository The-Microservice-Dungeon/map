# frozen_string_literal: true

class CreateSpawnCreations < ActiveRecord::Migration[6.1]
  def change
    create_table :spawn_creations, id: :uuid do |t|
      t.references :planet, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
