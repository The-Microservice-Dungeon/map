class UpdateMinings < ActiveRecord::Migration[6.1]
  def change
    remove_reference :minings, :resource_type, foreign_key: true
    add_reference :minings, :resource, null: false, foreign_key: true, type: :uuid
    add_column :minings, :amount_requested, :integer
  end
end
