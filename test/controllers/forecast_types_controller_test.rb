require 'test_helper'

class ForecastTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forecast_type_point, @forecast_type_probabilistic, @forecast_type_no_forecasts = forecast_types(:point, :probabilistic, :no_forecasts)
  end

  test "should get index" do
    get forecast_types_url, as: :json
    assert_response :success

    returned = response.parsed_body
    expected = {
      "forecast_types" => [
        forecast_type_api_attrs(@forecast_type_point),
        forecast_type_api_attrs(@forecast_type_probabilistic),
        forecast_type_api_attrs(@forecast_type_no_forecasts)
      ]
    }

    diff = HashDiff.diff expected, returned
    assert diff == []
  end

  test "should create forecast type" do
    assert_difference('ForecastType.count') do
      post forecast_types_url, params: {
        forecast_type: other_forecast_type_api_attrs()
      }, as: :json
    end

    assert_response 201

    returned = response.parsed_body
    expected = {
      "forecast_type" => other_forecast_type_api_attrs()
    }

    diff = HashDiff.diff expected, returned
    assert diff == [
      ["+", "forecast_type.id", returned["forecast_type"]["id"]]
    ]
  end

  test "should show forecast type" do
    get forecast_type_url(@forecast_type_point), as: :json
    assert_response :success

    returned = response.parsed_body
    expected = {
      "forecast_type" => forecast_type_api_attrs(@forecast_type_point)
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ]
  end

  test "should update forecast type" do
    patch forecast_type_url(@forecast_type_point), params: {
      forecast_type: other_forecast_type_api_attrs()
    }, as: :json

    assert_response 200

    returned = response.parsed_body
    expected = {
      "forecast_type" => forecast_type_api_attrs(@forecast_type_point).merge(other_forecast_type_api_attrs())
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ]
  end

  test "should destroy forecast type" do
    assert_difference('ForecastType.count', -1) do
      delete forecast_type_url(forecast_types(:no_forecasts)), as: :json
    end

    assert_response 204
  end

  test "should fail to create forecast type if no name" do
    post forecast_types_url, params: {
      forecast_type: other_forecast_type_api_attrs().except('atom')
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "name" => ['can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create forecast type if no label" do
    post forecast_types_url, params: {
      forecast_type: other_forecast_type_api_attrs().except('label')
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "label" => ['can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to delete forecast type if referenced by a forecast" do
    delete forecast_type_url(@forecast_type_point), as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "base" => ['Cannot delete record because dependent forecasts exist']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  def forecast_type_api_attrs(f)
    {
      "id" => f.id,
      "atom" => f.name,
      "label" => f.label
    }
  end

  def other_forecast_type_api_attrs()
    {
      "atom" => "other_forecast_type",
      "label" => "Other Forecast Type"
    }
  end
end
