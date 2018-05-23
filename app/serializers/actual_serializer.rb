class ActualSerializer < ActiveModel::Serializer
  attributes :id, :actual_mw, :farm_id
  attribute(:timestamp_utc) { object.timestamp_utc.iso8601 }
end
