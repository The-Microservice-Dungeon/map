# frozen_string_literal: true

json.array! @resources do |resource|
  json.partial! 'resource', resource: resource
end
