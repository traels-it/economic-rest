require 'test_helper'

class CustomerTest < Minitest::Test
  describe 'customer object' do
    it 'uses snaked cased attribute' do
      customers = Economic::Customer.all

      assert_equal customers[3].customer_number, 4
    end
  end
end
