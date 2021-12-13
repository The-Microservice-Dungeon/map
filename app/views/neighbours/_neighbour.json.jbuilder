# frozen_string_literal: true

json.call(neighbour, :id, :movement_difficulty, :recharge_multiplicator, :taken_at, :gameworld_id)
json.call(neighbour, :planet_type, :created_at, :updated_at)

neighbours = neighbour.neighbours.map do |neighbours_neighbour|
  { planet_id: neighbours_neighbour.id,
    movement_difficulty: neighbours_neighbour.movement_difficulty,
    direction: neighbour.direction_from_neighbour(neighbours_neighbour) }
end
json.neighbours(neighbours)

json.resource(neighbour.resource)
