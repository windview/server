require 'test_helper'

class FarmProvidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @farm_provider_a, @farm_provider_b, @farm_provider_no_farms = farm_providers(:a, :b, :no_farms)
  end

  test "should get index" do
    get farm_providers_url, as: :json
    assert_response :success

    returned = response.parsed_body
    expected = {
      "farm_providers" => [
        farm_provider_api_attrs(@farm_provider_a),
        farm_provider_api_attrs(@farm_provider_b),
        farm_provider_api_attrs(@farm_provider_no_farms)
      ]
    }

    diff = HashDiff.diff expected, returned
    assert diff == []
  end

  test "should create farm provider" do
    assert_difference('FarmProvider.count') do
      post farm_providers_url, params: {
        farm_provider: other_farm_provider_api_attrs()
      }, as: :json
    end

    assert_response 201

    returned = response.parsed_body
    expected = {
      "farm_provider" => other_farm_provider_api_attrs()
    }

    diff = HashDiff.diff expected, returned
    assert diff == [
      ["+", "farm_provider.id", returned["farm_provider"]["id"]]
    ]
  end

  test "should show farm_provider" do
    get farm_provider_url(@farm_provider_a), as: :json
    assert_response :success

    returned = response.parsed_body
    expected = {
      "farm_provider" => farm_provider_api_attrs(@farm_provider_a)
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ]
  end

  test "should update farm provider" do
    patch farm_provider_url(@farm_provider_a), params: {
      farm_provider: other_farm_provider_api_attrs()
    }, as: :json

    assert_response 200

    returned = response.parsed_body
    expected = {
      "farm_provider" => farm_provider_api_attrs(@farm_provider_a).merge(other_farm_provider_api_attrs())
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ]
  end

  test "should destroy farm provider" do
    assert_difference('FarmProvider.count', -1) do
      delete farm_provider_url(farm_providers(:no_farms)), as: :json
    end

    assert_response 204
  end

  test "should fail to create farm provider if no name" do
    post farm_providers_url, params: {
      farm_provider: other_farm_provider_api_attrs().except('atom')
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "name" => ['can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to create farm provider if no label" do
    post farm_providers_url, params: {
      farm_provider: other_farm_provider_api_attrs().except('label')
    }, as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "label" => ['can\'t be blank']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  test "should fail to delete farm provider if referenced by a farm" do
    delete farm_provider_url(@farm_provider_a), as: :json

    assert_response 422

    returned = response.parsed_body
    expected = {
      "base" => ['Cannot delete record because dependent farms exist']
    }

    diff = HashDiff.diff expected, returned
    assert diff == [ ], msg: diff
  end

  def farm_provider_api_attrs(f)
    {
      "id" => f.id,
      "atom" => f.name,
      "label" => f.label
    }
  end

  def other_farm_provider_api_attrs()
    {
      "atom" => "other_farm_provider",
      "label" => "Other Farm Provider"
    }
  end
end
