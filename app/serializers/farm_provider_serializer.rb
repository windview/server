class FarmProviderSerializer < ActiveModel::Serializer
  attributes :id, :label
  attribute :name, key: :atom
end
