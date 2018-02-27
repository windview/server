require 'test_helper'

class ActualsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @actual = actuals(:one)
  end

  test "should get index" do
    get actuals_url, as: :json
    assert_response :success
  end

  test "should create actual" do
    assert_difference('Actual.count') do
      post actuals_url, params: { actual: { actual_mw: @actual.actual_mw, farm_id: @actual.farm_id, timestamp: @actual.timestamp } }, as: :json
    end

    assert_response 201
  end

  test "should show actual" do
    get actual_url(@actual), as: :json
    assert_response :success
  end

  test "should update actual" do
    patch actual_url(@actual), params: { actual: { actual_mw: @actual.actual_mw, farm_id: @actual.farm_id, timestamp: @actual.timestamp } }, as: :json
    assert_response 200
  end

  test "should destroy actual" do
    assert_difference('Actual.count', -1) do
      delete actual_url(@actual), as: :json
    end

    assert_response 204
  end
end
