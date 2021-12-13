# frozen_string_literal: true

class AddDeletedAtToPlanet < ActiveRecord::Migration[6.1]
  def change
    add_column :planets, :deleted_at, :datetime
  end
end
