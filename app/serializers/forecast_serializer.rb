class ForecastSerializer < ActiveModel::Serializer
  attributes :id, :farm_id, :generated_at, :begins_at, :horizon_minutes
  attribute :forecast_provider_id, key: :provider_id
  attribute :forecast_provider_ref, key: :provider_forecast_ref
  attribute(:data) { JSON.parse(object.data) }

  belongs_to :forecast_type, key: :type
  def forecast_type
    object.forecast_type.name
  end
end
