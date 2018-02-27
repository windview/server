require 'test_helper'

class ForecastTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forecast_type = forecast_types(:one)
  end

  test "should get index" do
    get forecast_types_url, as: :json
    assert_response :success
  end

  test "should create forecast_type" do
    assert_difference('ForecastType.count') do
      post forecast_types_url, params: { forecast_type: { label: "#{@forecast_type.label} NEW", name: "#{@forecast_type.name}_new" } }, as: :json
    end

    assert_response 201
  end

  test "should show forecast_type" do
    get forecast_type_url(@forecast_type), as: :json
    assert_response :success
  end

  test "should update forecast_type" do
    patch forecast_type_url(@forecast_type), params: { forecast_type: { label: @forecast_type.label, name: @forecast_type.name } }, as: :json
    assert_response 200
  end

  test "should destroy forecast_type" do
    assert_difference('ForecastType.count', -1) do
      delete forecast_type_url(forecast_types(:no_forecasts)), as: :json
    end

    assert_response 204
  end
end
