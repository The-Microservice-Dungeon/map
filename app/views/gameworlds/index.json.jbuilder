json.array! @gameworlds do |gameworld|
  json.partial! 'gameworld', gameworld: gameworld
end
