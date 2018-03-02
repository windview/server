require 'test_helper'

class ForecastsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forecast_a, @forecast_b = forecasts(:a, :b)
  end

  test "should get index" do
    get forecasts_url, as: :json
    assert_response :success

    returned = response.parsed_body
    expected = {
      "forecasts" => [
        forecast_api_attrs(@forecast_a),
        forecast_api_attrs(@forecast_b),
      ]
    }

    diff = HashDiff.diff expected, returned
    assert diff == []
  end

  test "should create forecast" do
    assert_difference('Forecast.count') do
      post forecasts_url, params: {
        forecast: other_forecast_api_attrs()
      }, as: :json
    end

    assert_response 201

    returned = response.parsed_body
    expected = {
      "forecast" => other_forecast_api_attrs()
    }

    diff = HashDiff.diff expected, returned
    assert diff == [
      ["+", "forecast.id", returned["forecast"]["id"]]
    ]
  end

  test "should show forecast" do
    get forecast_url(@forecast_a), as: :json
    assert_response :success

    returned = response.parsed_body
    expected = {
      "forecast" => forecast_api_attrs(@forecast_a)
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ]
  end

  test "should update forecast" do
    patch forecast_url(@forecast_a), params: {
      forecast: other_forecast_api_attrs()
    }, as: :json

    assert_response 200

    returned = response.parsed_body
    expected = {
      "forecast" => forecast_api_attrs(@forecast_a).merge(other_forecast_api_attrs())
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ]
  end

  test "should destroy forecast" do
    assert_difference('Forecast.count', -1) do
      delete forecast_url(forecasts(:a)), as: :json
    end

    assert_response 204
  end

  def forecast_api_attrs(f)
    {
      "id" => f.id,
      "type" => f.forecast_type.name,
      "farm_id" => f.farm.id,
      "provider_id" => f.forecast_provider_id,
      "provider_forecast_ref" => f.forecast_provider_forecast_ref,
      "horizon_minutes" => f.horizon_minutes,
      "begins_at" => f.begins_at.iso8601,
      "generated_at" => f.generated_at.iso8601,
      "data" => JSON.parse(f.data)
    }
  end

  def other_forecast_api_attrs()
    {
      "type" => "point",
      "farm_id" => @forecast_a.farm_id,
      "provider_id" => @forecast_a.forecast_provider_id,
      "provider_forecast_ref" => "otherforecast",
      "horizon_minutes" => 60,
      "begins_at" => @forecast_a.begins_at.iso8601,
      "generated_at" => @forecast_a.generated_at.iso8601,
      "data" => [[0, 0]]
    }
  end
end
