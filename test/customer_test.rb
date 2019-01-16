require 'test_helper'

class CustomerTest < Minitest::Test
  describe 'customer object' do
    it 'uses snaked cased attribute' do
      customers = Economic::Customer.all

      assert_equal customers[3].customer_number, 4
    end

    it 'finds based on customer number' do
      customer = Economic::Customer.find(4)

      assert_equal customer.email, 'aaaa@aaa.com'
    end
  end
end
