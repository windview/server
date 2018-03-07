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
        forecast_api_attrs(forecasts(:for_forecasts_only))
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

  test "should fail to create without a farm id" do
    attrs = other_forecast_api_attrs().except('farm_id')

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "farm" => ['must exist', 'can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ]
  end

  test "should fail to create with bad farm id" do
    attrs = other_forecast_api_attrs().merge('farm_id' => -1)

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "farm" => ['must exist', 'can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create without a forecast type" do
    attrs = other_forecast_api_attrs().except('type')

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "forecast_type" => ['must exist', 'can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with bad forecast type" do
    attrs = other_forecast_api_attrs().merge('type' => 'random')

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "forecast_type" => ['must exist', 'can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with duplicate provider ref" do
    attrs = other_forecast_api_attrs().merge('provider_forecast_ref' => '1234')

    assert_difference('Forecast.count') do
      post forecasts_url, params: {
        forecast: attrs
      }, as: :json
    end

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "forecast_provider_forecast_ref" => ['has already been taken']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should create multiple with null provider ref" do
    attrs = other_forecast_api_attrs().except('provider_forecast_ref')
    assert_difference('Forecast.count') do
      post forecasts_url, params: {
        forecast: attrs
      }, as: :json
      assert_response 201
    end

    assert_difference('Forecast.count') do
      post forecasts_url, params: {
        forecast: attrs
      }, as: :json
      assert_response 201
    end

  end

  test "should create multiple with same provider ref but different providers" do
    attrs = other_forecast_api_attrs().merge('provider_forecast_ref' => '1234')
    assert_difference('Forecast.count') do
      post forecasts_url, params: {
        forecast: attrs.merge('provider_id' => @forecast_a.forecast_provider_id)
      }, as: :json
      assert_response 201
    end

    assert_difference('Forecast.count') do
      post forecasts_url, params: {
        forecast: attrs.merge('provider_id' => @forecast_b.forecast_provider_id)
      }, as: :json
      assert_response 201
    end

  end

  test "should show forecast" do
    get forecast_url(@forecast_a), as: :json
    assert_response :success

    returned = response.parsed_body
    expected = {
      "forecast" => forecast_api_attrs(@forecast_a)
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
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
    assert diff == [ ], msg: diff
  end

  test "should destroy forecast" do
    assert_difference('Forecast.count', -1) do
      delete forecast_url(forecasts(:a)), as: :json
    end

    assert_response 204
  end

  test "should fail to create without a begins at" do
    attrs = other_forecast_api_attrs().except('begins_at')

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "begins_at" => ['can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create without a generated at" do
    attrs = other_forecast_api_attrs().except('generated_at')

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "generated_at" => ['can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create without horizon minutes" do
    attrs = other_forecast_api_attrs().except('horizon_minutes')

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "horizon_minutes" => ['can\'t be blank', 'is not a number']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with bad horizon minutes: not a number" do
    attrs = other_forecast_api_attrs().merge('horizon_minutes' => 'adf')

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "horizon_minutes" => ['is not a number']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with bad horizon minutes: negative" do
    attrs = other_forecast_api_attrs().merge('horizon_minutes' => -34)

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "horizon_minutes" => ['must be greater than 0']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with bad horizon minutes: not an integer" do
    attrs = other_forecast_api_attrs().merge('horizon_minutes' => 3.4)

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "horizon_minutes" => ['must be an integer']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create without a data" do
    attrs = other_forecast_api_attrs().except('data')

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "data" => ['can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create bad data: hash instead of array" do
    attrs = other_forecast_api_attrs().merge('data' => '{}')

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "data" => ['must be a JSON array of arrays']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create bad data: empty 1D array" do
    attrs = other_forecast_api_attrs().merge('data' => '[]')

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "data" => ['must be a JSON array of arrays']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create bad data: any item is not an array" do
    attrs = other_forecast_api_attrs().merge('data' => '[[], {}]')

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "data" => ['must be a JSON array of arrays']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create bad data: not JSON" do
    attrs = other_forecast_api_attrs().merge('data' => '<data> bad </data>')

    post forecasts_url, params: {
      forecast: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "data" => ['must be a JSON array of arrays']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
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
