class AddResourceTypeEnum < ActiveRecord::Migration[6.1]
  def change
    add_column :planets, :resource_type, :integer, default: 0
    remove_reference :resources, :resource_type, foreign_key: true
    drop_table :resource_types
  end
end
