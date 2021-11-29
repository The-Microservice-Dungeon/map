class GameworldBuilder
  attr_reader :gameworld, :player_amount, :map_size

  def initialize(gameworld, player_amount, map_size)
    @gameworld = gameworld
    @player_amount = player_amount
    @map_size = map_size
  end

  def init_planets
    (0..@map_size - 1).each do |column|
      (0..@map_size - 1).each do |row|
        @gameworld.planets.create(x: column, y: row)
      end
    end
  end

  def create_spacestations
    border = 2

    possible_spacestations = @gameworld.planets.find_all do |p|
      p.x >= border &&
        p.y < @map_size - border   &&
        p.x < @map_size - border   &&
        p.y >= border &&
        p.deleted_at.nil?
    end

    possible_spacestations.sample(@map_size).each do |p|
      p.planet_type = 'spacestation'
      p.recharge_multiplicator = 2
      p.save!
    end
  end

  def create_spawns
    grid_size = @map_size - 1

    existing_planets = @gameworld.planets.find_all { |p| p.deleted_at.nil? }

    possible_spawns = existing_planets.find_all do |p|
      p.x.zero? ||
        p.x == grid_size ||
        p.y.zero? ||
        p.y == grid_size
    end

    distance_between_spawns = possible_spawns.size / @player_amount

    all_spawns = possible_spawns.select.with_index do |_p, i|
      ((i + 1) % distance_between_spawns).zero?
    end

    all_spawns.sample(@player_amount).sort_by { |s| s.y && s.x }.each do |p|
      p.planet_type = 'spawn'
      p.recharge_multiplicator = 2
      p.save!
    end
  end

  def delete_random_planets
    count_to_delete = @gameworld.planets.size.fdiv(10).ceil * rand(1..3).ceil
    deletable_planets = @gameworld.planets.select do |p|
      p.planet_type == 'default' && !inner_map?(p) && p.x != 1 && p.y != 1 && p.x != map_size - 2 && p.y != map_size - 2
    end.sample(count_to_delete)

    deletable_planets.each do |p|
      p.deleted_at = Time.now
      p.save!
    end
  end

  def add_movement_difficulty
    @gameworld.planets.each do |p|
      p.movement_difficulty = 2 if mid_map?(p)
      p.movement_difficulty = 3 if inner_map?(p)
      p.save!
    end
  end

  def create_resources
    resources = [
      { patch_amount: @gameworld.planets.size / 20, name: 'coal', part_of_map: :outer_map? },
      { patch_amount: @gameworld.planets.size / 30, name: 'iron', part_of_map: :mid_map? },
      { patch_amount: @gameworld.planets.size / 40, name: 'gem', part_of_map: :mid_map? },
      { patch_amount: @gameworld.planets.size / 50, name: 'gold', part_of_map: :inner_map? },
      { patch_amount: @gameworld.planets.size / 60, name: 'platin', part_of_map: :inner_map? }
    ]

    resources.each do |r|
      create_specific_resources(r[:name], r[:patch_amount], r[:part_of_map])
    end
  end

  def self.create_regular_gameworld(gameworld, player_amount)
    gameworld_builder = new(gameworld, player_amount, map_size(player_amount))
    gameworld_builder.init_planets
    gameworld_builder.add_movement_difficulty
    gameworld_builder.create_spawns
    gameworld_builder.create_spacestations
    gameworld_builder.delete_random_planets
    gameworld_builder.create_resources
    gameworld_builder
  end

  def self.map_size(player_amount)
    if player_amount < 10
      15
    elsif player_amount < 20
      20
    else
      35
    end
  end

  private

  def create_specific_resources(name, patch_amount, part_of_map)
    existing_planets = @gameworld.planets.find_all { |p| p.deleted_at.nil? }
    resource_planets = existing_planets.select do |p|
      method(part_of_map).call(p) && p.planet_type == 'default' && p.resource.nil?
    end.sample(patch_amount)

    resource_planets.each do |p|
      p.add_resource(name, 10_000)
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
    !inner_map?(planet) && !mid_map?(planet)
  end
end
