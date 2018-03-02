class Farm < ApplicationRecord
  belongs_to :farm_provider

  validates :farm_provider, presence: true
  validates :name, presence: true
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 } 
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 } 
  validates :capacity_mw, presence: true
end
