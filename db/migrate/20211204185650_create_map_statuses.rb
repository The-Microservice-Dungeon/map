class CreateMapStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :map_statuses, id: :uuid do |t|
      t.datetime :last_request_time

      t.timestamps
    end
  end
end
