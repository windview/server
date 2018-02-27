class Actual < ApplicationRecord
  belongs_to :farm

  validates :farm, presence: true
  validates :timestamp, presence: true
  validates :actual_mw, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
