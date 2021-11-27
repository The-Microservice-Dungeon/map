json.call(planet, :id, :movement_difficulty, :recharge_multiplicator, :taken_at, :gameworld_id)
json.call(planet, :planet_type, :neighbour_ids, :created_at, :updated_at)

json.resource(planet.resource)
