# frozen_string_literal: true

class CreateExplorations < ActiveRecord::Migration[6.1]
  def change
    create_table :explorations, id: :uuid do |t|
      t.references :planet, null: false, foreign_key: true, type: :uuid
      t.uuid :transaction_id, null: false

      t.timestamps
    end
  end
end
