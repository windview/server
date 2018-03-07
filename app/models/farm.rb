class Farm < ApplicationRecord
  belongs_to :farm_provider

  validates :farm_provider, presence: true
  validates :farm_provider_farm_ref, uniqueness: { scope: :farm_provider_id }, allow_blank: true
  validates :name, presence: true, uniqueness: { scope: :farm_provider_id }
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 } 
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 } 
  validates :capacity_mw, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_many :forecasts, dependent: :restrict_with_error
  has_many :actuals, dependent: :restrict_with_error
end
