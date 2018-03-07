require 'test_helper'

class ForecastProvidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forecast_provider_a, @forecast_provider_b, @forecast_provider_no_forecasts = forecast_providers(:a, :b, :no_forecasts)
  end

  test "should get index" do
    get forecast_providers_url, as: :json
    assert_response :success

    returned = response.parsed_body
    expected = {
      "forecast_providers" => [
        forecast_provider_api_attrs(@forecast_provider_a),
        forecast_provider_api_attrs(@forecast_provider_b),
        forecast_provider_api_attrs(@forecast_provider_no_forecasts)
      ]
    }

    diff = HashDiff.diff expected, returned
    assert diff == []
  end

  test "should create forecast provider" do
    assert_difference('ForecastProvider.count') do
      post forecast_providers_url, params: {
        forecast_provider: other_forecast_provider_api_attrs()
      }, as: :json
    end

    assert_response 201

    returned = response.parsed_body
    expected = {
      "forecast_provider" => other_forecast_provider_api_attrs()
    }

    diff = HashDiff.diff expected, returned
    assert diff == [
      ["+", "forecast_provider.id", returned["forecast_provider"]["id"]]
    ]
  end

  test "should show forecast provider" do
    get forecast_provider_url(@forecast_provider_a), as: :json
    assert_response :success

    returned = response.parsed_body
    expected = {
      "forecast_provider" => forecast_provider_api_attrs(@forecast_provider_a)
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ]
  end

  test "should update forecast provider" do
    patch forecast_provider_url(@forecast_provider_a), params: {
      forecast_provider: other_forecast_provider_api_attrs()
    }, as: :json

    assert_response 200

    returned = response.parsed_body
    expected = {
      "forecast_provider" => forecast_provider_api_attrs(@forecast_provider_a).merge(other_forecast_provider_api_attrs())
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ]
  end

  test "should destroy forecast provider" do
    assert_difference('ForecastProvider.count', -1) do
      delete forecast_provider_url(forecast_providers(:no_forecasts)), as: :json
    end

    assert_response 204
  end

  test "should fail to create forecast provider if no name" do
    post forecast_providers_url, params: {
      forecast_provider: other_forecast_provider_api_attrs().except('atom')
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "name" => ['can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create forecast provider if no label" do
    post forecast_providers_url, params: {
      forecast_provider: other_forecast_provider_api_attrs().except('label')
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "label" => ['can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  def forecast_provider_api_attrs(f)
    {
      "id" => f.id,
      "atom" => f.name,
      "label" => f.label
    }
  end

  def other_forecast_provider_api_attrs()
    {
      "atom" => "other_forecast_provider",
      "label" => "Other Forecast Provider"
    }
  end
end
