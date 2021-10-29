class UpdateReplenishments < ActiveRecord::Migration[6.1]
  def change
    remove_reference :replenishments, :resource_type, foreign_key: true
    add_reference :replenishments, :resource, null: false, foreign_key: true, type: :uuid
  end
end
