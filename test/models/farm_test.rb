require 'test_helper'

class FarmTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "farm_provider is required" do
    farm = farms(:a)
    farm.farm_provider = nil
    assert farm.save == false
    assert farm.errors[:farm_provider].include?('can\'t be blank')
  end
  
  test "name is required" do
    farm = farms(:a)
    farm.name = nil
    assert farm.save == false
    assert farm.errors[:name].include?('can\'t be blank')
  end

  test "latitude is required" do
    farm = farms(:a)
    farm.latitude = nil
    assert farm.save == false
    assert farm.errors[:latitude].include?('can\'t be blank')
  end

  test "latitude is greater than or equal to -90" do
    farm = farms(:a)
    farm.latitude = -181
    assert farm.save == false
    assert farm.errors[:latitude].include?('must be greater than or equal to -90')
  end

  test "latitude is less than or equal to 90" do
    farm = farms(:a)
    farm.latitude = 181
    assert farm.save == false
    assert farm.errors[:latitude].include?('must be less than or equal to 90')
  end

  test "longitude is required" do
    farm = farms(:a)
    farm.longitude = nil
    assert farm.save == false
    assert farm.errors[:longitude].include?('can\'t be blank')
  end

  test "longitude is greater than or equal to -180" do
    farm = farms(:a)
    farm.longitude = -181
    assert farm.save == false
    assert farm.errors[:longitude].include?('must be greater than or equal to -180')
  end

  test "longitude is less than or equal to 180" do
    farm = farms(:a)
    farm.longitude = 181
    assert farm.save == false
    assert farm.errors[:longitude].include?('must be less than or equal to 180')
  end

  test "capacity_mw is required" do
    farm = farms(:a)
    farm.capacity_mw = nil
    assert farm.save == false
    assert farm.errors[:capacity_mw].include?('can\'t be blank')
  end

end
