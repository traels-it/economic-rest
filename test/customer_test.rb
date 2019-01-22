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
      assert_kind_of Economic::Customer, customers[0]
    end

    it 'finds based on customer number' do
      stub_get_request(endpoint: 'customers', page_or_id: '4', fixture_name: 'customer')

      customer = Economic::CustomerRepo.find(4)

      assert_equal 'aaaa@aaa.com', customer.to_h['email']
      assert_kind_of Economic::Customer, customer
    end

    it 'can access attributes in camelCase' do
      c = Economic::Customer.new('corporateIdentificationNumber' => 1337)

      assert_equal 1337, c.corporateIdentificationNumber
      c.corporateIdentificationNumber = 222
      assert_equal 222, c.corporateIdentificationNumber
    end

    it 'assert no hashes in attributes' do
      stub_get_request(endpoint: 'customers', page_or_id: '4', fixture_name: 'customer')

      customer = Economic::CustomerRepo.find(4)

      Economic::Customer::ATTRIBUTES.each do |att|
        assert false, "#{att} was a hash" if customer.send(att).is_a?(Hash)
      end
    end

    it 'can access attributes in snake_case' do
      c = Economic::Customer.new('corporateIdentificationNumber' => 1337)

      assert_equal 1337, c.corporate_identification_number
      c.corporate_identification_number = 222
      assert_equal 222, c.corporate_identification_number
    end

    it 'assert no non-hashes in objects' do
      stub_get_request(endpoint: 'customers', page_or_id: '4', fixture_name: 'customer')

      customer = Economic::CustomerRepo.find(4)

      Economic::Customer::OBJECTS.each do |obj|
        assert false, "#{obj} was not a hash, customer.send(obj).inspect" unless customer.send(obj).is_a?(Hash) || customer.send(obj).nil?
      end
    end

    it 'can access objects in camelCase' do
      c = Economic::Customer.new('customerContact' => { 'customerContactNumber' => 97_939_393 } )

      assert_equal 97_939_393, c.customerContact['customerContactNumber']
      c.customerContact['customerContactNumber'] = 222
      assert_equal 222, c.customerContact['customerContactNumber']
    end

    it 'can access objects in snake_case' do
      c = Economic::Customer.new('customerContact' => { 'customerContactNumber' => 97_939_393, 'vatZoneNumber' => 'france' } )

      assert_equal 97_939_393, c.customer_contact['customer_contact_number']
      assert_equal 'france', c.customer_contact['vat_zone_number']
      c.customerContact['customer_contact_number'] = 222
      c.customerContact['vat_zone_number'] = 'germany'
      assert_equal 222, c.customerContact['customer_contact_number']
      assert_equal 'germany', c.customerContact['vat_zone_number']
    end

    it 'can access objects in mixed snake_case and camel case' do
      skip
      c = Economic::Customer.new('customerContact' => { 'customerContactNumber' => 97_939_393, 'vatZoneNumber' => 'france' } )

      assert_equal 97_939_393, c.customer_contact['customer_contact_number']
      assert_equal 'france', c.customer_contact['vatZoneNumber']
      c.customerContact['customerContactNumber'] = 222
      c.customerContact['vat_zone_number'] = 'germany'
      assert_equal 222, c.customerContact['customer_contact_number']
      assert_equal 'germany', c.customerContact['vat_zone_number']
    end

    it 'returns default not dirty' do
      stub_get_request(endpoint: 'customers', page_or_id: '4', fixture_name: 'customer')
      customer = Economic::CustomerRepo.find(4)

      refute customer.dirty?
    end

    it 'return dirty when dirty attribute' do
      stub_get_request(endpoint: 'customers', page_or_id: '4', fixture_name: 'customer')
      customer = Economic::CustomerRepo.find(4)

      customer.name = 'Biscuit'

      assert customer.dirty?
    end

    it 'returns json data based on changes to the model' do
      stub_get_request(endpoint: 'customers', page_or_id: '4', fixture_name: 'customer')
      customer = Economic::CustomerRepo.find(4)

      customer.name = 'Biscuit'

      assert customer.to_h.inspect.include? "Biscuit"
    end
  end
end
