# frozen_string_literal: true

json.array! @gameworlds do |gameworld|
  json.partial! 'gameworld', gameworld: gameworld
end
