class Forecast < ApplicationRecord
  belongs_to :farm
  belongs_to :forecast_type
  belongs_to :forecast_provider

  validates :farm, presence: true
  validates :forecast_type, presence: true
  validates :forecast_provider, presence: true
  validates :forecast_provider_forecast_ref, uniqueness: { scope: :forecast_provider_id }, allow_blank: true
  validates :generated_at, presence: true
  validates :begins_at, presence: true
  validates :horizon_minutes, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :data, presence: true
  validate :data_is_json_array_of_arrays

  @@BAD_DATA_VALUE_MSG = "must be a JSON array of arrays"
  def data_is_json_array_of_arrays
    if data.present?
      begin
        parsed_data = JSON.parse(data)
      rescue JSON::ParserError 
        errors.add(:data, @@BAD_DATA_VALUE_MSG)
        return
      end

      if !parsed_data.is_a?(Array)
        errors.add(:data, @@BAD_DATA_VALUE_MSG)
      elsif parsed_data.count < 1
        errors.add(:data, @@BAD_DATA_VALUE_MSG)
      elsif parsed_data.any? { |e| !e.is_a?(Array) }
        errors.add(:data, @@BAD_DATA_VALUE_MSG)
      end
    end
  end
end
