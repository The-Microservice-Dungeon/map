json.call(planet, :id, :movement_difficulty, :recharge_multiplicator, :gameworld_id)
json.call(planet, :planet_type, :created_at, :updated_at)

neighbours = planet.neighbours.map do |neighbour|
  { planet_id: neighbour.id, movement_difficulty: neighbour.movement_difficulty }
end
json.neighbours(neighbours)

json.resource(planet.resource)
