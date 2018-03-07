require 'test_helper'

class ForecastTest < ActiveSupport::TestCase
  test "farm is required" do
    forecast = forecasts(:a)
    forecast.farm = nil
    assert forecast.save == false
    assert forecast.errors[:farm].include?('can\'t be blank')
  end
  
  test "forecast_type is required" do
    forecast = forecasts(:a)
    forecast.forecast_type = nil
    assert forecast.save == false
    assert forecast.errors[:forecast_type].include?('can\'t be blank')
  end
  
  test "forecast_provider is required" do
    forecast = forecasts(:a)
    forecast.forecast_provider = nil
    assert forecast.save == false
    assert forecast.errors[:forecast_provider].include?('can\'t be blank')
  end
  
  test "generated_at is required" do
    forecast = forecasts(:a)
    forecast.generated_at = nil
    assert forecast.save == false
    assert forecast.errors[:generated_at].include?('can\'t be blank')
  end
  
  test "begins_at is required" do
    forecast = forecasts(:a)
    forecast.begins_at = nil
    assert forecast.save == false
    assert forecast.errors[:begins_at].include?('can\'t be blank')
  end
  
  test "horizon_minutes is required" do
    forecast = forecasts(:a)
    forecast.horizon_minutes = nil
    assert forecast.save == false
    assert forecast.errors[:horizon_minutes].include?('can\'t be blank')
  end
  
  test "horizon_minutes is a positive number" do
    forecast = forecasts(:a)
    forecast.horizon_minutes = -1
    assert forecast.save == false
    assert forecast.errors[:horizon_minutes].include?('must be greater than 0')
  end

  test "horizon_minutes is a an integer" do
    forecast = forecasts(:a)
    forecast.horizon_minutes = 1.039
    assert forecast.save == false
    assert forecast.errors[:horizon_minutes].include?('must be an integer')
  end

  test "data is required" do
    forecast = forecasts(:a)
    forecast.data = nil
    assert forecast.save == false
    assert forecast.errors[:data].include?('can\'t be blank')
  end
  
  test "data that is not JSON is invalid" do
    forecast = forecasts(:a)
    forecast.data = "asdf"
    assert forecast.save == false
    assert forecast.errors[:data].include?('must be a JSON array of arrays')
  end

  test "data that is an empty array is invalid" do
    forecast = forecasts(:a)
    forecast.data = "[]"
    assert forecast.save == false
    assert forecast.errors[:data].include?('must be a JSON array of arrays')
  end

  test "data that top level array element is not an array is invalid" do
    forecast = forecasts(:a)
    forecast.data = "[[], 5, []]"
    assert forecast.save == false
    assert forecast.errors[:data].include?('must be a JSON array of arrays')
  end
end
