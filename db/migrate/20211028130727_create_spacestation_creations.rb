# frozen_string_literal: true

class CreateSpacestationCreations < ActiveRecord::Migration[6.1]
  def change
    create_table :spacestation_creations, id: :uuid do |t|
      t.references :planet, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
