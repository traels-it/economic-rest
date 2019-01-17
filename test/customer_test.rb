require 'test_helper'

class CustomerTest < Minitest::Test
  describe 'customer object' do
    before do
      Economic::Session.authentication('Demo', 'Demo')
    end
    it 'gets all' do
      stub_get_request(endpoint: 'customers', pageindex: 0, fixture_name: 'customers_0')
      stub_get_request(endpoint: 'customers', pageindex: 1, fixture_name: 'customers_1')
      stub_get_request(endpoint: 'customers', pageindex: 2, fixture_name: 'customers_2')
      stub_get_request(endpoint: 'customers', pageindex: 3, fixture_name: 'customers_3')

      customers = Economic::CustomerRepo.all

      assert_equal 4, customers[3].to_h['customerNumber']
      assert_equal 3684, customers.length
    end

    it 'finds based on customer number' do
      stub_get_request(endpoint: 'customers', page_or_id: '4', fixture_name: 'customer')

      customer = Economic::CustomerRepo.find(4)

      assert_equal 'aaaa@aaa.com', customer.to_h['email']
    end
  end
end
