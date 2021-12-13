# frozen_string_literal: true

class CreateResources < ActiveRecord::Migration[6.1]
  def change
    create_table :resources, id: :uuid do |t|
      t.references :planet, null: false, foreign_key: true, type: :uuid
      t.references :resource_type, null: false, foreign_key: true, type: :uuid
      t.integer :max_amount
      t.integer :current_amount

      t.timestamps
    end
    add_index :resources, %i[planet_id resource_type_id], unique: true
  end
end
