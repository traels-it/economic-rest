require 'test_helper'

class EconomicTest < Minitest::Test
  describe 'test' do
    it 'test_that_it_has_a_version_number' do
      refute_nil Economic::Rest::VERSION
    end
  end
end
