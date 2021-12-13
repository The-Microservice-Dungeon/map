# frozen_string_literal: true

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
    planets = (0..@map_size - 1).map do |column|
      (0..@map_size - 1).map do |row|
        { id: SecureRandom.uuid,
          movement_difficulty: movement_difficulty(column, row),
          recharge_multiplicator: 1,
          gameworld_id: @gameworld.id,
          x: column,
          y: row,
          created_at: Time.now,
          updated_at: Time.now,
          planet_type: 'default',
          deleted_at: nil }
      end
    end.flatten

    spacestations = planets.filter do |planet|
      outer_map?(planet[:x], planet[:y])
    end.sample(@player_amount * 2).pluck(:x, :y)

    planets = planets.map do |planet|
      if spacestations.include?([planet[:x], planet[:y]])
        planet[:planet_type] = 'spacestation'
        planet[:recharge_multiplicator] = 2
      end
      planet
    end

    count_to_delete = planets.size.fdiv(10).ceil * rand(1..3).ceil

    deleted_planets = planets.filter do |planet|
      deletable_planet?(planet[:x], planet[:y], planet[:planet_type])
    end.sample(count_to_delete).pluck(:x, :y)

    planets = planets.map do |planet|
      planet[:deleted_at] = Time.now if deleted_planets.include?([planet[:x], planet[:y]])
      planet
    end

    Planet.insert_all(planets)
  end

  def movement_difficulty(x, y)
    return 3 if inner_map?(x, y)
    return 2 if mid_map?(x, y)

    1
  end

  def deletable_planet?(x, y, planet_type)
    planet_type == 'default' && !inner_map?(x, y) && x != 1 && y != 1 && x != @map_size - 2 && y != @map_size - 2
  end

  def self.create_regular_gameworld(gameworld, player_amount)
    gameworld_builder = new(gameworld, player_amount, map_size(player_amount))
    gameworld_builder.init_planets
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

  def inner_map?(x, y)
    grid_size = @map_size - 1
    inner = grid_size / 3
    x > inner && x < grid_size - inner && y > inner && y < grid_size - inner
  end

  def mid_map?(x, y)
    grid_size = @map_size - 1
    mid = grid_size / 3 / 2
    x > mid && x < grid_size - mid && y > mid && y < grid_size - mid
  end

  def outer_map?(x, y)
    !inner_map?(x, y) && !mid_map?(x, y)
  end
end
