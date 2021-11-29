class GameworldName < ActiveRecord::Migration[6.1]
  def change
    add_column :gameworlds, :name, :string
    add_column :gameworlds, :map_size, :integer
  end
end
