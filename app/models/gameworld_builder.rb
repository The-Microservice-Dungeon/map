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

  def create_spacestations
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
      ((i + 1) % distance_between_spawns).zero?
    end

    all_spawns.pop if all_spawns.size > @player_amount

    all_spawns.sort_by { |s| s.y && s.x }.each do |p|
      p.planet_type = 'spawn'
      p.recharge_multiplicator = 2
    end
  end

  def add_movement_difficulty
    @gameworld.planets.each do |p|
      p.movement_difficulty = 3 if inner_map?(p)
      p.movement_difficulty = 2 if mid_map?(p)
    end
  end

  def neighbour_planets
    @gameworld.planets.each do |planet|
      neighbours = get_neighbours(planet)
      neighbours.each { |neighbour| planet.add_neighbour(neighbour) }
    end
  end

  def create_recources
    resources = [
      { patch_amount: @gameworld.planets.size / 10, name: 'coal', part_of_map: :outer_map? },
      { patch_amount: @gameworld.planets.size / 20, name: 'iron', part_of_map: :mid_map? },
      { patch_amount: @gameworld.planets.size / 30, name: 'gem', part_of_map: :mid_map? },
      { patch_amount: @gameworld.planets.size / 40, name: 'gold', part_of_map: :inner_map? },
      { patch_amount: @gameworld.planets.size / 50, name: 'platin', part_of_map: :inner_map? }
    ]

    resources.each do |r|
      create_specific_resources(r[:name], r[:patch_amount], r[:part_of_map])
    end
  end

  private

  def create_specific_resources(name, patch_amount, part_of_map)
    coal_planets = @gameworld.planets.select do |p|
      method(part_of_map).call(p) && p.planet_type == 'default' && p.resources.empty?
    end.sample(patch_amount)

    coal_planets.each do |p|
      p.add_resource(ResourceType.find_by(name: name).id, 10_000)
    end
  end

  def inner_map?(planet)
    grid_size = @map_size - 1
    inner = grid_size / 3
    planet.x > inner && planet.x < grid_size - inner && planet.y > inner && planet.y < grid_size - inner
  end

  def mid_map?(planet)
    grid_size = @map_size - 1
    mid = grid_size / 3 / 2
    planet.x > mid && planet.x < grid_size - mid && planet.y > mid && planet.y < grid_size - mid
  end

  def outer_map?(planet)
    !inner_map?(planet) || !mid_map?(planet)
  end

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
