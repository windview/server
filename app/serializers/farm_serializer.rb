class FarmSerializer < ActiveModel::Serializer
  attributes :id, :name, :capacity_mw, :latitude, :longitude
  
  attribute :farm_provider_id, key: :provider_id

  attribute :farm_provider_farm_ref, key: :provider_farm_ref

end
