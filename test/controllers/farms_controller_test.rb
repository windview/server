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
        farm_api_attrs(@farm_no_forecasts_no_actuals),
        farm_api_attrs(farms(:actuals_only)),
        farm_api_attrs(farms(:forecasts_only))
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

  test "should fail to create without a farm provider" do
    attrs = other_farm_api_attrs().except('provider_id')

    post farms_url, params: {
      farm: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "farm_provider" => ['must exist', 'can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ]
  end

  test "should fail to create with bad farm provider id" do
    attrs = other_farm_api_attrs().merge('provider_id' => -1)

    post farms_url, params: {
      farm: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "farm_provider" => ['must exist', 'can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create without a name" do
    attrs = other_farm_api_attrs().except('name')

    post farms_url, params: {
      farm: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "name" => ['can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with duplicate name for provider" do
    attrs = other_farm_api_attrs().merge('name' => '1234')

    assert_difference('Farm.count') do
      post farms_url, params: {
        farm: attrs.merge('provider_farm_ref' => '1')
      }, as: :json
    end

    post farms_url, params: {
      farm: attrs.merge('provider_farm_ref' => '2')
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "name" => ['has already been taken']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should create multiple with same name but different providers" do
    attrs = other_farm_api_attrs().merge('name' => '1234')
    assert_difference('Farm.count') do
      post farms_url, params: {
        farm: attrs.merge('provider_id' => @farm_a.farm_provider_id)
      }, as: :json
      assert_response 201
    end

    assert_difference('Farm.count') do
      post farms_url, params: {
        farm: attrs.merge('provider_id' => @farm_b.farm_provider_id)
      }, as: :json
      assert_response 201
    end

  end

  test "should fail to create with duplicate provider ref" do
    attrs = other_farm_api_attrs().merge('provider_farm_ref' => '1234')

    assert_difference('Farm.count') do
      post farms_url, params: {
        farm: attrs.merge('name' => '1')
      }, as: :json
    end

    post farms_url, params: {
      farm: attrs.merge('name' => '2')
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "farm_provider_farm_ref" => ['has already been taken']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should create multiple with null provider ref" do
    attrs = other_farm_api_attrs().except('provider_farm_ref')
    assert_difference('Farm.count') do
      post farms_url, params: {
        farm: attrs.merge('name' => '1')
      }, as: :json
      assert_response 201
    end

    assert_difference('Farm.count') do
      post farms_url, params: {
        farm: attrs.merge('name' => '2')
      }, as: :json
      assert_response 201
    end

  end

  test "should create multiple with same provider ref but different providers" do
    attrs = other_farm_api_attrs().merge('provider_farm_ref' => '1234')
    assert_difference('Farm.count') do
      post farms_url, params: {
        farm: attrs.merge('provider_id' => @farm_a.farm_provider_id)
      }, as: :json
      assert_response 201
    end

    assert_difference('Farm.count') do
      post farms_url, params: {
        farm: attrs.merge('provider_id' => @farm_b.farm_provider_id)
      }, as: :json
      assert_response 201
    end

  end

  test "should fail to create without capacity mw" do
    attrs = other_farm_api_attrs().except('capacity_mw')

    post farms_url, params: {
      farm: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "capacity_mw" => ['can\'t be blank', 'is not a number']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with bad capacity mw: not a number" do
    attrs = other_farm_api_attrs().merge('capacity_mw' => 'adf')

    post farms_url, params: {
      farm: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "capacity_mw" => ['is not a number']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with bad capacity mw: negative" do
    attrs = other_farm_api_attrs().merge('capacity_mw' => -34)

    post farms_url, params: {
      farm: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "capacity_mw" => ['must be greater than or equal to 0']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create without longitude" do
    attrs = other_farm_api_attrs().except('longitude')

    post farms_url, params: {
      farm: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "longitude" => ['can\'t be blank', 'is not a number']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with bad longitude: not a number" do
    attrs = other_farm_api_attrs().merge('longitude' => 'adf')

    post farms_url, params: {
      farm: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "longitude" => ['is not a number']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with bad longitude: less than -180" do
    attrs = other_farm_api_attrs().merge('longitude' => -181)

    post farms_url, params: {
      farm: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "longitude" => ['must be greater than or equal to -180']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with bad longitude: greater than 180" do
    attrs = other_farm_api_attrs().merge('longitude' => 181)

    post farms_url, params: {
      farm: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "longitude" => ['must be less than or equal to 180']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create without latitude" do
    attrs = other_farm_api_attrs().except('latitude')

    post farms_url, params: {
      farm: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "latitude" => ['can\'t be blank', 'is not a number']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with bad latitude: not a number" do
    attrs = other_farm_api_attrs().merge('latitude' => 'adf')

    post farms_url, params: {
      farm: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "latitude" => ['is not a number']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with bad latitude: less than -90" do
    attrs = other_farm_api_attrs().merge('latitude' => -91)

    post farms_url, params: {
      farm: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "latitude" => ['must be greater than or equal to -90']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with bad latitude: greater than 90" do
    attrs = other_farm_api_attrs().merge('latitude' => 91)

    post farms_url, params: {
      farm: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "latitude" => ['must be less than or equal to 90']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to delete farm if referenced by a forecast" do
    delete farm_url(farms(:forecasts_only)), as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "base" => ['Cannot delete record because dependent forecasts exist']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to delete farm if referenced by an actual" do
    delete farm_url(farms(:actuals_only)), as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "base" => ['Cannot delete record because dependent actuals exist']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
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
