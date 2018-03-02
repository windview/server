require 'test_helper'

class FarmProvidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @farm_provider_a, @farm_provider_b, @farm_provider_no_farms = farm_providers(
        :a, :b, :no_farms)
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
        farm: farm_provider_api_attrs(@farm_provider_a).except("id")
      }, as: :json
    end

    assert_response 201

    returned = response.parsed_body
    expected = {
      "farm_provider" => farm_provider_api_attrs(@farm_provider_a)
    }

    diff = HashDiff.diff expected, returned
    assert diff == [
      ["~", "farm.id", expected["farm_provider"]["id"], returned["farm_provider"]["id"]]
    ]
  end

  test "should show farm provider" do
    get farm_provider_url(@farm_provider_a), as: :json
    assert_response :success

    returned = response.parsed_body
    expected = {
      "farm_provider" => farm_provider_api_attrs(@farm_provider_a)
    }

    diff = HashDiff.diff expected, returned
    puts "XAJA| diff: #{diff}"
    assert diff == [ ]
  end

  test "should update farm provider" do
    patch farm_provider_url(@farm_provider_a), params: {
      farm_provider: new_farm_provider_api_attrs(@farm_provider_b)
    }, as: :json

    assert_response 200

    returned = response.parsed_body
    expected = {
      "farm_provider" => farm_provider_api_attrs(@farm_provider_b).merge({"id" => @farm_provider_a.id})
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

  def farm_provider_api_attrs(f)
    {
      "id" => f.id,
      "atom" => f.name,
      "label" => f.label
    }
  end

  def new_farm_provider_api_attrs(f)
    {
      "atom" => "#{f.name}_new" ,
      "label" => "#{f.label}_new"
    }
  end
end
