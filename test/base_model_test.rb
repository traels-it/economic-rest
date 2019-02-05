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

  describe '.relations' do
    it 'list relations with details on model' do
      assert_equal [{ name: 'baseModelRelation', fields: [:baseModelRelationNumber] }], Economic::BaseModel.relations
    end
  end

  describe 'initialize' do
    it 'fills in attributes from hash-values' do
      base_model = Economic::BaseModel.new('corporateIdentificationNumber' => 1337)

      assert_equal 1337, base_model.corporate_identification_number
      assert_equal 1337, base_model.corporateIdentificationNumber
    end

    it 'creates and populates relations from hash-values' do
      base_model = Economic::BaseModel.new('baseModelRelation' => { 'baseModelRelationNumber' => 97_939_393 })
    end
  end
end
