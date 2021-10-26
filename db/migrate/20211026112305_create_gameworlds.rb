class CreateGameworlds < ActiveRecord::Migration[6.1]
  def change
    create_table :gameworlds, id: :uuid do |t|
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
