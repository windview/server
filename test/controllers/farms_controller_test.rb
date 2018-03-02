require 'test_helper'

class FarmsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @farm_a, @farm_b, @farm_no_forecasts_no_actuals = farms(:a, :b, :no_forecasts_no_actuals)
  end

  test "should get index" do
    get farms_url, as: :json
    assert_response :success

    returned = response.parsed_body
    expected = {
      "farms" => [
        farm_api_attrs(@farm_a),
        farm_api_attrs(@farm_b),
        farm_api_attrs(@farm_no_forecasts_no_actuals)
      ]
    }

    diff = HashDiff.diff expected, returned
    assert diff == []
  end

  test "should create farm" do
    assert_difference('Farm.count') do
      post farms_url, params: {
        farm: other_farm_api_attrs()
      }, as: :json
    end

    assert_response 201

    returned = response.parsed_body
    expected = {
      "farm" => other_farm_api_attrs()
    }

    diff = HashDiff.diff expected, returned
    assert diff == [
      ["+", "farm.id", returned["farm"]["id"]]
    ]
  end

  test "should show farm" do
    get farm_url(@farm_a), as: :json
    assert_response :success

    returned = response.parsed_body
    expected = {
      "farm" => farm_api_attrs(@farm_a)
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ]
  end

  test "should update farm" do
    patch farm_url(@farm_a), params: {
      farm: other_farm_api_attrs()
    }, as: :json

    assert_response 200

    returned = response.parsed_body
    expected = {
      "farm" => farm_api_attrs(@farm_a).merge(other_farm_api_attrs())
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ]
  end

  test "should destroy farm" do
    assert_difference('Farm.count', -1) do
      delete farm_url(farms(:no_forecasts_no_actuals)), as: :json
    end

    assert_response 204
  end

  def farm_api_attrs(f)
    {
      "id" => f.id,
      "name" => f.name,
      "capacity_mw" => f.capacity_mw,
      "provider_id" => f.farm_provider_id,
      "provider_farm_ref" => f.farm_provider_farm_ref,
      "longitude" => f.longitude,
      "latitude" => f.latitude
    }
  end

  def other_farm_api_attrs()
    {
      "name" => "Other Farm",
      "capacity_mw" => 5.5,
      "provider_id" => @farm_a.farm_provider_id,
      "provider_farm_ref" => "otherfarm",
      "longitude" => 20.1,
      "latitude" => 20.2
    }
  end
end
