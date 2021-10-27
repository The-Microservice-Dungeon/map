class GameworldBuilder
  attr_reader :gameworld

  def initialize(_player_amount, _round_amount)
    @gameworld = Gameworld.new

    (0..9).each do |column|
      (0..9).each do |row|
        @gameworld.planets.build(x: column, y: row)
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

    neighbours.push(planets.find { |p| p.x == (x - 1) && p.y == y }) if top_neighbour?(planets, x, y)
    neighbours.push(planets.find { |p| p.x == (x + 1) && p.y == y }) if bottom_neighbour?(planets, x, y)
    neighbours.push(planets.find { |p| p.x == x && p.y == (y - 1) }) if left_neighbour?(planets, x, y)
    neighbours.push(planets.find { |p| p.x == x && p.y == (y + 1) }) if right_neighbour?(planets, x, y)

    neighbours
  end

  def top_neighbour?(planets, x, y)
    x.positive? && planets.any? { |p| p.x == (x - 1) && p.y == y }
  end

  def bottom_neighbour?(planets, x, y)
    x < planets.length - 1 && planets.any? { |p| p.x == (x + 1) && p.y == y }
  end

  def left_neighbour?(planets, x, y)
    planets.any? { |p| p.x == x && p.y == (y - 1) }
  end

  def right_neighbour?(planets, x, y)
    planets.any? { |p| p.x == x && p.y == (y + 1) }
  end
end
