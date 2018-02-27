require 'test_helper'

class FarmProvidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @farm_provider = farm_providers(:one)
  end

  test "should get index" do
    get farm_providers_url, as: :json
    assert_response :success
  end

  test "should create farm_provider" do
    assert_difference('FarmProvider.count') do
      post farm_providers_url, params: { farm_provider: { label: "#{@farm_provider.label} NEW", name: "#{@farm_provider.name}_new" } }, as: :json
    end

    assert_response 201
  end

  test "should show farm_provider" do
    get farm_provider_url(@farm_provider), as: :json
    assert_response :success
  end

  test "should update farm_provider" do
    patch farm_provider_url(@farm_provider), params: { farm_provider: { label: @farm_provider.label, name: @farm_provider.name } }, as: :json
    assert_response 200
  end

  test "should destroy farm_provider" do
    assert_difference('FarmProvider.count', -1) do
      delete farm_provider_url(farm_providers(:no_farms)), as: :json
    end

    assert_response 204
  end
end
