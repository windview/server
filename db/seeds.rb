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


_point_forecast_type = ForecastType.create!({
    name: "point",
    label: "Point Forecast",
})
_probabilistic_forecast_type = ForecastType.create!({
    name: "probabilistic",
    label: "Probabilistic Forecast",
})
