class CreateResourceTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :resource_types, id: :uuid do |t|
      t.integer :difficulty, default: 0
      t.integer :name

      t.timestamps
    end
  end
end
