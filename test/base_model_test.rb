require 'test_helper'

module Economic
  class BaseModel < Base
    field :corporateIdentificationNumber
    field :customerContact
  end
end

class BaseModelTest < Minitest::Test
  describe 'snake cased versions of attributes' do
    it 'can access attributes in snake_case' do
      base_model = Economic::BaseModel.new('corporateIdentificationNumber' => 1337)

      assert_equal 1337, base_model.corporate_identification_number
      base_model.corporate_identification_number = 222
      assert_equal 222, base_model.corporate_identification_number
    end

    it 'can access objects' do
      base_model = Economic::BaseModel.new('customerContact' => { 'customerContactNumber' => 97_939_393, 'vatZoneNumber' => 'france' })

      assert_equal 97_939_393, base_model.customer_contact['customer_contact_number']
      assert_equal 'france', base_model.customer_contact['vat_zone_number']
      base_model.customerContact['customer_contact_number'] = 222
      base_model.customerContact['vat_zone_number'] = 'germany'
      assert_equal 222, base_model.customerContact['customer_contact_number']
      assert_equal 'germany', base_model.customerContact['vat_zone_number']
    end
  end

  describe 'camelCased versions of attributes' do
    it 'can access attributes' do
      base_model = Economic::BaseModel.new('corporateIdentificationNumber' => 1337)

      assert_equal 1337, base_model.corporateIdentificationNumber
      base_model.corporateIdentificationNumber = 222
      assert_equal 222, base_model.corporateIdentificationNumber
    end

    it 'can access objects' do
      base_model = Economic::BaseModel.new('customerContact' => { 'customerContactNumber' => 97_939_393 })

      assert_equal 97_939_393, base_model.customerContact['customerContactNumber']
      base_model.customerContact['customerContactNumber'] = 222
      assert_equal 222, base_model.customerContact['customerContactNumber']
    end
  end
end
