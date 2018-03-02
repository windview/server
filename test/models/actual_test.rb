require 'test_helper'

class ActualTest < ActiveSupport::TestCase
  test "farm is required" do
    actual = actuals(:a)
    actual.farm = nil
    assert actual.save == false
    assert actual.errors[:farm].include?('can\'t be blank')
  end
  
  test "timestamp is required" do
    actual = actuals(:a)
    actual.timestamp = nil
    assert actual.save == false
    assert actual.errors[:timestamp].include?('can\'t be blank')
  end

  test "actual_mw is required" do
    actual = actuals(:a)
    actual.actual_mw = nil
    assert actual.save == false
    assert actual.errors[:actual_mw].include?('can\'t be blank')
  end

  test "actual_mw is a positive number" do
    actual = actuals(:a)
    actual.actual_mw = -1.3
    assert actual.save == false
    assert actual.errors[:actual_mw].include?('must be greater than or equal to 0')
  end
end
