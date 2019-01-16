require 'test_helper'

class CustomerTest < Minitest::Test
  describe 'customer object' do
    it 'uses snaked cased attribute' do
      customers = Economic::CustomerRepo.all

      assert_equal customers[3].to_h['customerNumber'], 4
    end

    it 'finds based on customer number' do
      customer = Economic::CustomerRepo.find(4)

      assert_equal 'aaaa@aaa.com', customer.to_h['email']
    end
  end
end
