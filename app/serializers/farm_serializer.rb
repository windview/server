class FarmSerializer < ActiveModel::Serializer
  attributes :id, :name, :capacity_mw
  
  attribute :farm_provider_id, key: :provider_id

  attribute :farm_provider_ref, key: :provider_farm_ref
  attribute :lng, key: :longitude
  attribute :lat, key: :latitude

end
