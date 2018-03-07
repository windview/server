class ForecastProvider < ApplicationRecord
  validates :name, presence: true
  validates :label, presence: true

  has_many :forecasts, dependent: :restrict_with_error
end


