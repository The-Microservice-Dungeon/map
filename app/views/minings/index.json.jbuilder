json.array! @minings do |mining|
  json.partial! 'mining', mining: mining
end
