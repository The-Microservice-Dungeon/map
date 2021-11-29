class GameworldBuilder
  attr_reader :gameworld, :player_amount, :map_size

  def initialize(gameworld, player_amount, map_size)
    @gameworld = gameworld
    @player_amount = player_amount
    @map_size = map_size
    @gameworld.map_size = map_size
    @gameworld.save
  end

  def init_planets
    (0..@map_size - 1).each do |column|
      (0..@map_size - 1).each do |row|
        @gameworld.planets.create(x: column, y: row)
      end
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

  def self.create_regular_gameworld(gameworld, player_amount)
    gameworld_builder = new(gameworld, player_amount, map_size(player_amount))
    gameworld_builder.init_planets
    gameworld_builder.create_spawns
    CreateGameworldSpacestationsJob.perform_later(gameworld.id)
    CreateGameworldDeletePlanetsJob.perform_later(gameworld.id)
    CreateGameworldMovementDifficultyJob.perform_later(gameworld.id)
    CreateGameworldResourcesJob.perform_later(gameworld.id)
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
end
