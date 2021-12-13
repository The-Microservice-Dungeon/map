# frozen_string_literal: true

class UpdateEventScheme < ActiveRecord::Migration[6.1]
  def change
    add_column :minings, :version, :integer, default: 1
    add_column :replenishments, :version, :integer, default: 1
    add_column :explorations, :version, :integer, default: 1
    add_column :spawn_creations, :version, :integer, default: 1
    add_column :spacestation_creations, :version, :integer, default: 1

    add_column :minings, :transaction_id, :uuid
    add_column :replenishments, :transaction_id, :uuid
    add_column :spawn_creations, :transaction_id, :uuid
    add_column :spacestation_creations, :transaction_id, :uuid
  end
end
