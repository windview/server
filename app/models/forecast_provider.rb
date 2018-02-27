class ForecastProvider < ApplicationRecord
  validates :name, presence: true
  validates :label, presence: true
end


