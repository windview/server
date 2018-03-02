class ForecastProviderSerializer < ActiveModel::Serializer
  attributes :id, :label
  attribute :name, key: :atom
end
