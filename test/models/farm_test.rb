require 'test_helper'

class FarmTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "farm_provider is required" do
    farm = farms(:one)
    farm.farm_provider = nil
    assert farm.save == false
    assert farm.errors[:farm_provider].include?('can\'t be blank')
  end
  
  test "name is required" do
    farm = farms(:one)
    farm.name = nil
    assert farm.save == false
    assert farm.errors[:name].include?('can\'t be blank')
  end

  test "lat is required" do
    farm = farms(:one)
    farm.lat = nil
    assert farm.save == false
    assert farm.errors[:lat].include?('can\'t be blank')
  end

  test "lat is greater than or equal to -90" do
    farm = farms(:one)
    farm.lat = -181
    assert farm.save == false
    assert farm.errors[:lat].include?('must be greater than or equal to -90')
  end

  test "lat is less than or equal to 90" do
    farm = farms(:one)
    farm.lat = 181
    assert farm.save == false
    assert farm.errors[:lat].include?('must be less than or equal to 90')
  end

  test "lng is required" do
    farm = farms(:one)
    farm.lng = nil
    assert farm.save == false
    assert farm.errors[:lng].include?('can\'t be blank')
  end

  test "lng is greater than or equal to -180" do
    farm = farms(:one)
    farm.lng = -181
    assert farm.save == false
    assert farm.errors[:lng].include?('must be greater than or equal to -180')
  end

  test "lng is less than or equal to 180" do
    farm = farms(:one)
    farm.lng = 181
    assert farm.save == false
    assert farm.errors[:lng].include?('must be less than or equal to 180')
  end

  test "capacity_mw is required" do
    farm = farms(:one)
    farm.capacity_mw = nil
    assert farm.save == false
    assert farm.errors[:capacity_mw].include?('can\'t be blank')
  end

end
