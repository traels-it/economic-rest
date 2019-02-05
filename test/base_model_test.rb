require 'test_helper'

module Economic
  class BaseModelRelation < Base
    field :baseModelRelationNumber
  end

  class BaseModel < Base
    field :corporateIdentificationNumber
    field :name

    relation :baseModelRelation, fields: [:baseModelRelationNumber]
  end
end

class BaseModelTest < Minitest::Test
  describe '.attributes' do
    it 'list attributes on model' do
      assert_equal %w[corporateIdentificationNumber name], Economic::BaseModel.attributes
    end
  end

  describe 'snake cased versions of attributes' do
    it 'can access attributes in snake_case' do
      base_model = Economic::BaseModel.new('corporateIdentificationNumber' => 1337)

      assert_equal 1337, base_model.corporate_identification_number
      base_model.corporate_identification_number = 222
      assert_equal 222, base_model.corporate_identification_number
    end

    it 'can access objects' do
      base_model = Economic::BaseModel.new('baseModelRelation' => { 'baseModelRelationNumber' => 97_939_393, 'vatZoneNumber' => 'france' })
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
      base_model = Economic::BaseModel.new('baseModelRelation' => { 'baseModelRelationNumber' => 97_939_393 })
    end
  end
end
