require 'test_helper'

class ForecastProviderTest < ActiveSupport::TestCase
  test "name is required" do
    forecast_provider = forecast_providers(:a)
    forecast_provider.name = nil
    assert forecast_provider.save == false
    assert forecast_provider.errors[:name].include?('can\'t be blank')
  end

  test "label is required" do
    forecast_provider = forecast_providers(:a)
    forecast_provider.label = nil
    assert forecast_provider.save == false
    assert forecast_provider.errors[:label].include?('can\'t be blank')
  end
end


