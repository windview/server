require 'test_helper'

class ForecastProvidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forecast_provider = forecast_providers(:one)
  end

  test "should get index" do
    get forecast_providers_url, as: :json
    assert_response :success
  end

  test "should create forecast_provider" do
    assert_difference('ForecastProvider.count') do
      post forecast_providers_url, params: { forecast_provider: { label: @forecast_provider.label, name: @forecast_provider.name } }, as: :json
    end

    assert_response 201
  end

  test "should show forecast_provider" do
    get forecast_provider_url(@forecast_provider), as: :json
    assert_response :success
  end

  test "should update forecast_provider" do
    patch forecast_provider_url(@forecast_provider), params: { forecast_provider: { label: @forecast_provider.label, name: @forecast_provider.name } }, as: :json
    assert_response 200
  end

  test "should destroy forecast_provider" do
    assert_difference('ForecastProvider.count', -1) do
      delete forecast_provider_url(@forecast_provider), as: :json
    end

    assert_response 204
  end
end
