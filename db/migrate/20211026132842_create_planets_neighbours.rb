class CreatePlanetsNeighbours < ActiveRecord::Migration[6.1]
  def change
    create_table :planets_neighbours, id: false do |t|
      t.uuid :planet_id
      t.uuid :neighbour_id
    end
    add_index :planets_neighbours, %i[planet_id neighbour_id], unique: true
  end
end
