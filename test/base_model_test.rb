require 'test_helper'

module Economic
  class BaseModelRelation < Base
    field :baseModelRelationNumber
    field :notInHash
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

      assert_kind_of Economic::BaseModelRelation, base_model.base_model_relation
      assert_equal 97_939_393, base_model.baseModelRelation.base_model_relation_number
      assert_equal 97_939_393, base_model.base_model_relation.base_model_relation_number
    end

    it 'is not the same for 2 different base model' do
      base_model = Economic::BaseModel.new('baseModelRelation' => { 'baseModelRelationNumber' => 97_939_393 })

      base_model2 = Economic::BaseModel.new('baseModelRelation' => { 'baseModelRelationNumber' => 97_222 })

      refute_equal base_model.base_model_relation, base_model2.base_model_relation
    end
  end

  describe 'to_h' do
    it 'returns attributes' do
      h = { 'corporateIdentificationNumber' => 1337 }
      base_model = Economic::BaseModel.new(h)

      assert_equal h, base_model.to_h
    end

    it 'returns relations' do
      h = { 'baseModelRelation' => { 'baseModelRelationNumber' => 97_939_393 } }
      base_model = Economic::BaseModel.new(h)

      assert_equal h, base_model.to_h
    end

    it 'only includes relation fields mentioned in relations' do
      h = { 'baseModelRelation' => { 'baseModelRelationNumber' => 97_939_393, 'notInHash' => 4711 } }

      base_model = Economic::BaseModel.new(h)

      h_expected = { 'baseModelRelation' => { 'baseModelRelationNumber' => 97_939_393 } }
      assert_equal h_expected, base_model.to_h
    end
  end
end
