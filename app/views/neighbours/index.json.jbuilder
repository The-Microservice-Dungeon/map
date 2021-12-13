# frozen_string_literal: true

json.array! @neighbours do |neighbour|
  json.partial! 'neighbour', neighbour: neighbour
end
