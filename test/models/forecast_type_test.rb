require 'test_helper'

class ForecastTypeTest < ActiveSupport::TestCase
  test "name is required" do
    forecast_type = forecast_types(:point)
    forecast_type.name = nil
    assert forecast_type.save == false
    assert forecast_type.errors[:name].include?('can\'t be blank')
  end

  test "label is required" do
    forecast_type = forecast_types(:point)
    forecast_type.label = nil
    assert forecast_type.save == false
    assert forecast_type.errors[:label].include?('can\'t be blank')
  end
end


