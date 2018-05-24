require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest

  test "should get appropriate error for unpermitted parameters" do
    get forecasts_url(foo: 'bar', bad: 'jamon')
    assert_response :unprocessable_entity

    returned = response.parsed_body
    expected = {
      'errors' => {
        'invalid_params' => ['bad', 'foo']
      }
    }

    diff = HashDiff.diff expected, returned
    assert diff == [], msg: diff
  end

  test "should get appropriate error for unknown parameters" do
    post forecasts_url(forecast: { foo: 'bar', bad: 'jamon' })
    assert_response :unprocessable_entity

    returned = response.parsed_body
    expected = {
      'errors' => {
        'invalid_params' => ['bad']
      }
    }

    diff = HashDiff.diff expected, returned
    assert diff == [], msg: diff
  end
end
