class CreateReplenishments < ActiveRecord::Migration[6.1]
  def change
    create_table :replenishments, id: :uuid do |t|
      t.references :planet, null: false, foreign_key: true, type: :uuid
      t.references :resource_type, null: false, foreign_key: true, type: :uuid
      t.integer :amount_replenished

      t.timestamps
    end
  end
end
