json.array! @neighbours do |neighbour|
  json.partial! 'neighbour', neighbour: neighbour
end
