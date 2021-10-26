class CreatePlanets < ActiveRecord::Migration[6.1]
  def change
    create_table :planets, id: :uuid do |t|
      t.integer :movement_difficulty
      t.integer :recharge_multiplicator
      t.integer :planet_type, default: 0
      t.datetime :taken_at
      t.references :gameworld, null: false, foreign_key: true, type: :uuid
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
