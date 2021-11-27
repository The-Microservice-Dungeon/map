class GameworldPrinter
  def self.print_gameworld(gwb, margin_width = 2)
    gameworld = gameworld_to_stringified_2d_array(gwb)

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

    (0..grid_size).map do |y|
      (0..grid_size).map do |x|
        gameworld.planets.find { |p| p.x == x && p.y == y }
      end
    end
  end

  def self.gameworld_to_stringified_2d_array(gwb)
    gameworld = gwb.gameworld
    map_size = gwb.map_size - 1

    (0..map_size).map do |x|
      (0..map_size).map do |y|
        planet = gameworld.planets.find { |p| p.x == x && p.y == y }
        if planet
          resource_type_name = planet.resources.any? ? planet.resources.first.resource_type : 'NORESOURCE'
          "#{planet.planet_type} #{planet.movement_difficulty} #{planet.recharge_multiplicator} #{resource_type_name}"
        else
          'NOPLANET'
        end
      end
    end
  end
end
