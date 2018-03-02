require 'test_helper'

class ForecastsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forecast = forecasts(:a)
  end

  test "should get index" do
    get forecasts_url, as: :json
    assert_response :success
  end

  test "should create forecast" do
    assert_difference('Forecast.count') do
        post forecasts_url, params: { forecast: { begins_at: @forecast.begins_at, data: @forecast.data, farm_id: @forecast.farm_id, forecast_provider_ref: @forecast.forecast_provider_ref, forecast_provider_id: @forecast.forecast_provider_id, forecast_type_id: @forecast.forecast_type_id, generated_at: @forecast.generated_at, horizon_minutes: @forecast.horizon_minutes } }, as: :json
    end

    assert_response 201
  end

  test "should show forecast" do
    get forecast_url(@forecast), as: :json
    assert_response :success
  end

  test "should update forecast" do
    patch forecast_url(@forecast), params: { forecast: { begins_at: @forecast.begins_at, data: @forecast.data, farm_id: @forecast.farm_id, forecast_provider_ref: @forecast.forecast_provider_ref, forecast_provider_id: @forecast.forecast_provider_id, forecast_type_id: @forecast.forecast_type_id, generated_at: @forecast.generated_at, horizon_minutes: @forecast.horizon_minutes } }, as: :json
    assert_response 200
  end

  test "should destroy forecast" do
    assert_difference('Forecast.count', -1) do
      delete forecast_url(@forecast), as: :json
    end

    assert_response 204
  end
end
