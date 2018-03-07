require 'test_helper'

class ActualsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @actual_a, @actual_b = actuals(:a, :b)
  end

  test "should get index" do
    get actuals_url, as: :json
    assert_response :success

    returned = response.parsed_body
    expected = {
      "actuals" => [
        actual_api_attrs(@actual_a),
        actual_api_attrs(@actual_b),
        actual_api_attrs(actuals(:for_actuals_only))
      ]
    }

    diff = HashDiff.diff expected, returned
    assert diff == [], msg: diff
  end

  test "should create actual" do
    assert_difference('Actual.count') do
      post actuals_url, params: {
        actual: other_actual_api_attrs()
      }, as: :json
    end

    assert_response 201

    returned = response.parsed_body
    expected = {
      "actual" => other_actual_api_attrs()
    }

    diff = HashDiff.diff expected, returned
    assert diff == [
      ["+", "actual.id", returned["actual"]["id"]]
    ], msg: diff
  end

  test "should show actual" do
    get actual_url(@actual_a), as: :json
    assert_response :success

    returned = response.parsed_body
    expected = {
      "actual" => actual_api_attrs(@actual_a)
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should update actual" do
    patch actual_url(@actual_a), params: {
      actual: other_actual_api_attrs()
    }, as: :json

    assert_response 200

    returned = response.parsed_body
    expected = {
      "actual" => actual_api_attrs(@actual_a).merge(other_actual_api_attrs())
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should destroy actual" do
    assert_difference('Actual.count', -1) do
      delete actual_url(actuals(:a)), as: :json
    end

    assert_response 204
  end


  test "should fail to create without a farm id" do
    attrs = other_actual_api_attrs().except('farm_id')

    post actuals_url, params: {
      actual: attrs
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
    attrs = other_actual_api_attrs().merge('farm_id' => -1)

    post actuals_url, params: {
      actual: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "farm" => ['must exist', 'can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create without actual mw" do
    attrs = other_actual_api_attrs().except('actual_mw')

    post actuals_url, params: {
      actual: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "actual_mw" => ['can\'t be blank', 'is not a number']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with bad actual mw: not a number" do
    attrs = other_actual_api_attrs().merge('actual_mw' => 'adf')

    post actuals_url, params: {
      actual: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "actual_mw" => ['is not a number']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create with bad actual mw: negative" do
    attrs = other_actual_api_attrs().merge('actual_mw' => -34)

    post actuals_url, params: {
      actual: attrs
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "actual_mw" => ['must be greater than or equal to 0']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  def actual_api_attrs(a)
    {
      "id" => a.id,
      "farm_id" => a.farm_id,
      "timestamp" => a.timestamp.iso8601,
      "actual_mw" => a.actual_mw
    }
  end

  def other_actual_api_attrs()
    {
      "farm_id" => @actual_b.farm_id,
      "timestamp" => @actual_b.timestamp.iso8601,
      "actual_mw" => 9.3
    }
  end
end
