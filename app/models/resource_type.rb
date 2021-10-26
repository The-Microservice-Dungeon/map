class ResourceType < ApplicationRecord
  enum name: %i[coal iron gem gold platin]
  validates :name, inclusion: { in: names.keys }
end
