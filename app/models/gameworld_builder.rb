class GameworldBuilder
  attr_reader :gameworld, :player_amount, :round_amount

  def initialize(player_amount, round_amount)
    @gameworld = Gameworld.new
    @player_amount = player_amount
    @round_amount = round_amount

    (0..9).each do |column|
      (0..9).each do |row|
        @gameworld.planets.build(x: column, y: row)
      end
    end
  end

  #TODO: be careful with comma values
  def create_spawns
    grid_size = Math.sqrt(@gameworld.planets.size) - 1
    possible_spawns = @gameworld.planets.find_all do |p|
      p.x == 0 ||
      p.x == grid_size ||
      p.y == 0 ||
      p.y == grid_size
    end
    distance_between_spawns = possible_spawns.size / @player_amount
    all_spawns = possible_spawns.select.with_index do |p, i|
      i % distance_between_spawns == 0
    end
    all_spawns.each do |p|
      p.planet_type = 'spawn'
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
