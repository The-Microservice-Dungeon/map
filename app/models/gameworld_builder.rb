class GameworldBuilder
  attr_reader :gameworld, :player_amount, :map_size

  def initialize(player_amount, map_size)
    @gameworld = Gameworld.new
    @player_amount = player_amount
    @map_size = map_size

    (0..map_size - 1).each do |column|
      (0..map_size - 1).each do |row|
        @gameworld.planets.build(x: column, y: row)
      end
    end
  end

  def create_spacestation
    border = 2
    possible_spacestations = @gameworld.planets.find_all do |p|
      p.x >= border &&
        p.y < @map_size - border   &&
        p.x < @map_size - border   &&
        p.y >= border
    end
    spacestation_amount = possible_spacestations.size.fdiv(100) * @player_amount

    all_spacestations = possible_spacestations.sample(spacestation_amount)

    all_spacestations.each do |p|
      p.planet_type = 'spacestation'
      p.recharge_multiplicator = 2
    end
  end

  def create_spawns
    grid_size = Math.sqrt(@gameworld.planets.size) - 1

    possible_spawns = @gameworld.planets.find_all do |p|
      p.x.zero? ||
        p.x == grid_size ||
        p.y.zero? ||
        p.y == grid_size
    end

    distance_between_spawns = possible_spawns.size / @player_amount

    all_spawns = possible_spawns.select.with_index do |_p, i|
      i % distance_between_spawns == 0
    end

    all_spawns.pop if all_spawns.size > @player_amount

    all_spawns.each do |p|
      p.planet_type = 'spawn'
      p.recharge_multiplicator = 2
    end
  end

  def add_movement_difficulty
    grid_size = Math.sqrt(@gameworld.planets.size) - 1
    inner = grid_size / 3
    mid = grid_size / 3 / 2

    @gameworld.planets.each do |p|
      if p.x > inner && p.x < grid_size - inner && p.y > inner && p.y < grid_size - inner
        p.movement_difficulty = 3
      elsif p.x > mid && p.x < grid_size - mid && p.y > mid && p.y < grid_size - mid
        p.movement_difficulty = 2
      end
    end
  end

  def neighbour_planets
    @gameworld.planets.each do |planet|
      neighbours = get_neighbours(planet)
      neighbours.each { |neighbour| planet.add_neighbour(neighbour) }
    end
  end

  def add_resources_to_world
    planets = @gameworld.planets.size
    resource_patch_amount = [planets / 10, planets / 20, planets / 30, planets / 40, planets / 50]
    resource_patch_amount.each_with_index do | resource_type , index |
      
    end
  end

  private

  def get_neighbours(planet)
    neighbours = []
    x = planet.x
    y = planet.y
    planets = @gameworld.planets

    neighbours.push(top_neighbour(planets, x, y))
    neighbours.push(bottom_neighbour(planets, x, y))
    neighbours.push(left_neighbour(planets, x, y))
    neighbours.push(right_neighbour(planets, x, y))

    neighbours.compact
  end

  def top_neighbour(planets, x, y)
    planets.find { |p| p.x == (x - 1) && p.y == y }
  end

  def bottom_neighbour(planets, x, y)
    planets.find { |p| p.x == (x + 1) && p.y == y }
  end

  def left_neighbour(planets, x, y)
    planets.find { |p| p.x == x && p.y == (y - 1) }
  end

  def right_neighbour(planets, x, y)
    planets.find { |p| p.x == x && p.y == (y + 1) }
  end
end
