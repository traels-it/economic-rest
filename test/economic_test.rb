require 'test_helper'

class EconomicTest < Minitest::Test
  describe 'test' do
    it 'test_that_it_has_a_version_number' do
      refute_nil Economic::Rest::VERSION
    end

    it 'test_if_demo_rest_api_is_down' do
      response = Economic::Demo.hello

      assert_equal response.code, 200
    end
  end
end
