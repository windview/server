class ActualSerializer < ActiveModel::Serializer
  attributes :id, :actual_mw, :farm_id
  attribute(:timestamp) { object.timestamp.iso8601 }
end
