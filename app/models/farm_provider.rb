class FarmProvider < ApplicationRecord
  validates :name, presence: true
  validates :label, presence: true

  has_many :farms, dependent: :restrict_with_error
end
