# frozen_string_literal: true

class CreateMinings < ActiveRecord::Migration[6.1]
  def change
    create_table :minings, id: :uuid do |t|
      t.references :planet, null: false, foreign_key: true, type: :uuid
      t.integer :amount_mined
      t.references :resource_type, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
