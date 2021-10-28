class GameworldPrinter
  def self.print_gameworld(gameworld, margin_width = 2)
    gameworld = gameworld_to_stringified_2d_array(gameworld)

    column_widths = []
    gameworld.each do |row|
      row.each.with_index do |cell, column_num|
        column_widths[column_num] = [column_widths[column_num] || 0, cell.to_s.size].max
      end
    end

    puts(
      gameworld.collect do |row|
        row.collect.with_index do |cell, column_num|
          cell.to_s.ljust(column_widths[column_num] + margin_width)
        end.join
      end
    )
  end

  def self.gameworld_to_2d_array(gameworld)
    grid_size = Math.sqrt(gameworld.planets.size) - 1

    (0..grid_size).map do |x|
      (0..grid_size).map do |y|
        gameworld.planets.find { |p| p.x == x && p.y == y }
      end
    end
  end

  def self.gameworld_to_stringified_2d_array(gameworld)
    grid_size = Math.sqrt(gameworld.planets.size) - 1

    (0..grid_size).map do |x|
      (0..grid_size).map do |y|
        planet = gameworld.planets.find { |p| p.x == x && p.y == y }
        if planet
          "#{planet.planet_type} #{planet.movement_difficulty} #{planet.recharge_multiplicator}"
        else
          'NOPLANET'
        end
      end
    end
  end
end
