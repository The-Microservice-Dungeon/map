# frozen_string_literal: true

##
# GameworldBuilder
#
# This code is creating a gameworld with planets. The movement difficulty of the planets
# depends on their position in the map. If they are at the edges it's 1 if they are
# in the middle it's 2 and for the inner map it's 3.
#
# Random planets in the outer map are set to the `spacestation` type. Those planets have a
# recharge_multiplicator of 2.
#
# Random planets are also soft deleted by setting the `deleted_at` field. Those planets are not
# shown in the `neighbours` array of other planets, and don't have resources and can't be spacestations.
#
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
    create_resources
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

  def create_specific_resources(name, patch_amount, part_of_map)
    existing_planets = @gameworld
                       .planets.left_joins(:resource)
                       .where(deleted_at: nil,
                              planet_type: 'default',
                              resource: { planet_id: nil })
    resource_planets = existing_planets.select do |p|
      p.method(part_of_map).call
    end

    resources = resource_planets.sample(patch_amount).map do |p|
      { id: SecureRandom.uuid,
        planet_id: p.id,
        resource_type: name,
        max_amount: 10_000,
        current_amount: 10_000,
        created_at: Time.now,
        updated_at: Time.now }
    end

    Resource.insert_all(resources)
  end
end
