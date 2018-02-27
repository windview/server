class Forecast < ApplicationRecord
  belongs_to :farm
  belongs_to :forecast_type
  belongs_to :forecast_provider
end
