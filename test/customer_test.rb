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

    it 'can access attributes in snake_case' do
      c = Economic::Customer.new('corporateIdentificationNumber' => 1337)

      assert_equal 1337, c.corporate_identification_number
      c.corporate_identification_number = 222
      assert_equal 222, c.corporate_identification_number
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

      assert customer.to_h.inspect.include? 'Biscuit'
    end

    it 'saves' do
      stub_get_request(endpoint: 'customers', page_or_id: '1', fixture_name: 'customer')
      stub_get_request(endpoint: 'customers', page_or_id: '1', fixture_name: 'customer', method: :put)
      customer = Economic::CustomerRepo.find(1)

      customer.address = 'High road 32'
      customer.save

      assert_equal 'High road 32', customer.address
    end

    it 'makes a new customer that is reloaded from economics after saving' do
      stub_request(:post, "https://restapi.e-conomic.com/customers/")
        .with(body: "{\"currency\":\"DKK\",\"paymentTerms\":{\"paymentTermsNumber\":5,\"payment_terms_number\":5},\"customerGroup\":{\"customerGroupNumber\":1,\"customer_group_number\":1},\"name\":\"Horsens Kommune\",\"vatZone\":{\"vatZoneNumber\":1,\"vat_zone_number\":1}}")
        .to_return(status: 200, body: '{"customerNumber":201,"currency":"DKK","paymentTerms":{"paymentTermsNumber":5,"self":"https://restapi.e-conomic.com/payment-terms/5"},"customerGroup":{"customerGroupNumber":1,"self":"https://restapi.e-conomic.com/customer-groups/1"},"address":"High road 32","balance":151875.00,"dueAmount":151875.00,"city":"Horsens","name":"Horsens Kommune","zip":"8700","telephoneAndFaxNumber":"7629 2929","vatZone":{"vatZoneNumber":1,"self":"https://restapi.e-conomic.com/vat-zones/1"},"layout":{"layoutNumber":16,"self":"https://restapi.e-conomic.com/layouts/16"},"lastUpdated":"2019-01-22T16:03:55Z","contacts":"https://restapi.e-conomic.com/customers/201/contacts","templates":{"invoice":"https://restapi.e-conomic.com/customers/201/templates/invoice","invoiceLine":"https://restapi.e-conomic.com/customers/201/templates/invoiceline","self":"https://restapi.e-conomic.com/customers/201/templates"},"totals":{"drafts":"https://restapi.e-conomic.com/invoices/totals/drafts/customers/201","booked":"https://restapi.e-conomic.com/invoices/totals/booked/customers/201","self":"https://restapi.e-conomic.com/customers/201/totals"},"deliveryLocations":"https://restapi.e-conomic.com/customers/201/delivery-locations","invoices":{"drafts":"https://restapi.e-conomic.com/customers/201/invoices/drafts","booked":"https://restapi.e-conomic.com/customers/201/invoices/booked","self":"https://restapi.e-conomic.com/customers/201/invoices"},"metaData":{"delete":{"description":"Delete this customer.","href":"https://restapi.e-conomic.com/customers/201","httpMethod":"delete"},"replace":{"description":"Replace this customer.","href":"https://restapi.e-conomic.com/customers/201","httpMethod":"put"}},"self":"https://restapi.e-conomic.com/customers/201"}', headers: {})
      customer = Economic::Customer.new("currency": 'DKK', "paymentTerms": { "paymentTermsNumber": 5 }, "customerGroup": { "customerGroupNumber": 1 }, "name": 'Horsens Kommune', "vatZone": { "vatZoneNumber": 1 })

      customer.save

      assert customer.customer_number
    end
    it 'changes saves changes to an object value' do
      stub_get_request(endpoint: 'customers', page_or_id: '1', fixture_name: 'customer')
      stub_get_request(endpoint: 'customers', page_or_id: '1', fixture_name: 'customer', method: :put)
      customer = Economic::CustomerRepo.find(1)

      customer.payment_terms = { 'paymentTermsNumber' => 5 }

      assert customer.dirty?
      customer.save
      refute customer.dirty?

      assert_equal 5, customer.payment_terms['payment_terms_number']
    end
  end
end
