# frozen_string_literal: true

json.array! @planets do |planet|
  json.partial! 'planet', planet: planet
end
