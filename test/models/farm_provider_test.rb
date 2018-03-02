require 'test_helper'

class FarmProviderTest < ActiveSupport::TestCase
  test "name is required" do
    farm_provider = farm_providers(:a)
    farm_provider.name = nil
    assert farm_provider.save == false
    assert farm_provider.errors[:name].include?('can\'t be blank')
  end

  test "label is required" do
    farm_provider = farm_providers(:a)
    farm_provider.label = nil
    assert farm_provider.save == false
    assert farm_provider.errors[:label].include?('can\'t be blank')
  end
end
