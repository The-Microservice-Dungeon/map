class AddResourceTypeEnum < ActiveRecord::Migration[6.1]
  def change
    remove_reference :resources, :resource_type, foreign_key: true
    drop_table :resource_types
    add_column :resources, :resource_type, :integer, default: 0
  end
end
