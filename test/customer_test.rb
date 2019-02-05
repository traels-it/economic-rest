require 'test_helper'

class CustomerTest < Minitest::Test
  describe 'For customer' do
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
      c = Economic::Customer.new('customerContact' => { 'customerContactNumber' => 97_939_393 })

      assert_equal 97_939_393, c.customerContact['customerContactNumber']
      c.customerContact['customerContactNumber'] = 222
      assert_equal 222, c.customerContact['customerContactNumber']
    end

    it 'can access objects in snake_case' do
      c = Economic::Customer.new('customerContact' => { 'customerContactNumber' => 97_939_393, 'vatZoneNumber' => 'france' })

      assert_equal 97_939_393, c.customer_contact['customer_contact_number']
      assert_equal 'france', c.customer_contact['vat_zone_number']
      c.customerContact['customer_contact_number'] = 222
      c.customerContact['vat_zone_number'] = 'germany'
      assert_equal 222, c.customerContact['customer_contact_number']
      assert_equal 'germany', c.customerContact['vat_zone_number']
    end

    it 'can access objects in mixed snake_case and camel case' do
      skip
      c = Economic::Customer.new('customerContact' => { 'customerContactNumber' => 97_939_393, 'vatZoneNumber' => 'france' })

      assert_equal 97_939_393, c.customer_contact['customer_contact_number']
      assert_equal 'france', c.customer_contact['vatZoneNumber']
      c.customerContact['customerContactNumber'] = 222
      c.customerContact['vat_zone_number'] = 'germany'
      assert_equal 222, c.customerContact['customer_contact_number']
      assert_equal 'germany', c.customerContact['vat_zone_number']
    end
  end
end
