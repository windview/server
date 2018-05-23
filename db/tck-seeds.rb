# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# CLEAN
Forecast.delete_all
ForecastType.delete_all
ForecastProvider.delete_all
Actual.delete_all
Farm.delete_all
FarmProvider.delete_all

def parse_iso8601(date)
  Time.parse(date)
end

# FarmProvider
a_farm_provider = FarmProvider.create!({
    name: "a_farm_provider",
    label: "Provider A"
})

a_farm_1 =
  Farm.create!({
    name: "A Farm 1",
    farm_provider_id: a_farm_provider.id,
    farm_provider_farm_ref: "a_farm_1_ref",
    longitude: -96.1,
    latitude: 38.1,
    capacity_mw: 10
  });

a_farm_2 =
  Farm.create!({
    name: "A Farm 2",
    farm_provider_id: a_farm_provider.id,
    farm_provider_farm_ref: "a_farm_2_ref",
    longitude: -96.2,
    latitude: 38.2,
    capacity_mw: 20
  })

a_farm_3 =
  Farm.create!({
    name: "A Farm 3",
    farm_provider_id: a_farm_provider.id,
    farm_provider_farm_ref: "a_farm_3_ref",
    longitude: -96.3,
    latitude: 38.3,
    capacity_mw: 30
  })

b_farm_provider =
  FarmProvider.create!({
      name: "b_farm_provider",
      label: "Provider B"
  })

b_farm_1 =
  Farm.create({
    name: "B Farm 1",
    farm_provider_id: b_farm_provider.id,
    farm_provider_farm_ref: "b_farm_1_ref",
    longitude: -96.1,
    latitude: 38.1,
    capacity_mw: 10
  })

b_farm_2 =
  Farm.create!({
    name: "B Farm 2",
    farm_provider_id: a_farm_provider.id,
    farm_provider_farm_ref: "b_farm_2_ref",
    longitude: -96.2,
    latitude: 38.2,
    capacity_mw: 20
  })

c_farm_provider =
  FarmProvider.create({
      name: "c_farm_provider",
      label: "Provider C"
  })

# ForecastProvider
a_forecast_provider = ForecastProvider.create!({name: "a_forecast_provider", label: "Provider A"})
b_forecast_provider = ForecastProvider.create!({name: "b_forecast_provider", label: "Provider B"})
c_forecast_provider = ForecastProvider.create!({name: "c_forecast_provider", label: "Provider C"})

# ForecastType
probabilistic_type = ForecastType.create!({name: "probabilistic", label: "Probabilistic Forecast"})

point_type = ForecastType.create({name: "point", label: "Point Forecast"})

# Forecasts - a_farm_1, point, day ahead
# -------------------------------------------------------------------------
generated_at = parse_iso8601("2021-04-14T05:00:00.000000Z")
begins_at = parse_iso8601("2021-04-14T06:00:00.000000Z")

Forecast.create!({
  farm_id: a_farm_1.id,
  forecast_provider_id: a_forecast_provider.id,
  forecast_provider_forecast_ref: "a_a_forecast_1",
  forecast_type_id: point_type.id,
  generated_at: generated_at,
  horizon_minutes: 1440,
  begins_at: begins_at,
  data: [[]]
})

generated_at = parse_iso8601("2021-04-14T06:00:00.000000Z")
begins_at = parse_iso8601("2021-04-14T07:00:00.000000Z")

Forecast.create!({
  farm_id: a_farm_1.id,
  forecast_provider_id: a_forecast_provider.id,
  forecast_provider_forecast_ref: "a_a_forecast_2",
  forecast_type_id: point_type.id,
  generated_at: generated_at,
  horizon_minutes: 1440,
  begins_at: begins_at,
  data: [[]]
})

generated_at = parse_iso8601("2021-04-14T07:00:00.000000Z")
begins_at = parse_iso8601("2021-04-14T08:00:00.000000Z")

Forecast.create!({
  farm_id: a_farm_1.id,
  forecast_provider_id: a_forecast_provider.id,
  forecast_provider_forecast_ref: "a_a_forecast_3",
  forecast_type_id: point_type.id,
  generated_at: generated_at,
  horizon_minutes: 1440,
  begins_at: begins_at,
  data: [[]]
})

# Forecasts - a_farm_1, probabilistic, day ahead
# -------------------------------------------------------------------------
generated_at = parse_iso8601("2021-04-14T05:30:00.000000Z")
begins_at = parse_iso8601("2021-04-14T06:30:00.000000Z")

Forecast.create!({
  farm_id: a_farm_1.id,
  forecast_provider_id: a_forecast_provider.id,
  forecast_provider_forecast_ref: "a_a_forecast_4",
  forecast_type_id: probabilistic_type.id,
  generated_at: generated_at,
  horizon_minutes: 1440,
  begins_at: begins_at,
  data: [[]]
})

generated_at = parse_iso8601("2021-04-14T06:30:00.000000Z")
begins_at = parse_iso8601("2021-04-14T07:30:00.000000Z")

Forecast.create({
  farm_id: a_farm_1.id,
  forecast_provider_id: a_forecast_provider.id,
  forecast_provider_forecast_ref: "a_a_forecast_5",
  forecast_type_id: probabilistic_type.id,
  generated_at: generated_at,
  horizon_minutes: 1440,
  begins_at: begins_at,
  data: [[]]
})

# Forecast
generated_at = parse_iso8601("2021-04-14T07:30:00.000000Z")
begins_at = parse_iso8601("2021-04-14T08:30:00.000000Z")

Forecast.create!({
  farm_id: a_farm_1.id,
  forecast_provider_id: a_forecast_provider.id,
  forecast_provider_forecast_ref: "a_a_forecast_6",
  forecast_type_id: probabilistic_type.id,
  generated_at: generated_at,
  horizon_minutes: 1440,
  begins_at: begins_at,
  data: [[]]
})

# Forecasts - a_farm_2, point, day ahead
# -------------------------------------------------------------------------
generated_at = parse_iso8601("2021-04-14T05:00:00.000000Z")
begins_at = parse_iso8601("2021-04-14T06:00:00.000000Z")

Forecast.create!({
  farm_id: a_farm_2.id,
  forecast_provider_id: a_forecast_provider.id,
  forecast_provider_forecast_ref: "a_a_forecast_7",
  forecast_type_id: point_type.id,
  generated_at: generated_at,
  horizon_minutes: 1440,
  begins_at: begins_at,
  data: [[]]
})

generated_at = parse_iso8601("2021-04-14T06:00:00.000000Z")
begins_at = parse_iso8601("2021-04-14T07:00:00.000000Z")

Forecast.create!({
  farm_id: a_farm_2.id,
  forecast_provider_id: a_forecast_provider.id,
  forecast_provider_forecast_ref: "a_a_forecast_8",
  forecast_type_id: point_type.id,
  generated_at: generated_at,
  horizon_minutes: 1440,
  begins_at: begins_at,
  data: [[]]
})

generated_at = parse_iso8601("2021-04-14T07:00:00.000000Z")
begins_at = parse_iso8601("2021-04-14T08:00:00.000000Z")

Forecast.create!({
  farm_id: a_farm_2.id,
  forecast_provider_id: a_forecast_provider.id,
  forecast_provider_forecast_ref: "a_a_forecast_9",
  forecast_type_id: point_type.id,
  generated_at: generated_at,
  horizon_minutes: 1440,
  begins_at: begins_at,
  data: [[]]
})

# Actuals a_farm_1
# -------------------------------------------------------------------------
timestamp = parse_iso8601("2021-04-14T07:00:00.000000Z")

Actual.create!({
  farm_id: a_farm_1.id,
  timestamp_utc: timestamp,
  actual_mw: 2.1
})

Actual.create!({
  farm_id: a_farm_1.id,
  timestamp_utc: timestamp + 60,
  actual_mw: 2.2
})

Actual.create!({
  farm_id: a_farm_1.id,
  timestamp_utc: timestamp + 60,
  actual_mw: 2.2
})

Actual.create!({
  farm_id: a_farm_1.id,
  timestamp_utc: timestamp + 60,
  actual_mw: 2.8
})

# Actuals b_farm_2
# -------------------------------------------------------------------------
Actual.create!({
  farm_id: b_farm_2.id,
  timestamp_utc: timestamp,
  actual_mw: 4.1
})

Actual.create!({
  farm_id: b_farm_2.id,
  timestamp_utc: timestamp + 60,
  actual_mw: 4.2
})
