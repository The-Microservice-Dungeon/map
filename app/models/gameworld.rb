class Gameworld < ApplicationRecord
  enum status: %i[active inactive], _default: :active
  validates :status, inclusion: { in: statuses.keys }

  has_many :planets, dependent: :destroy
end
