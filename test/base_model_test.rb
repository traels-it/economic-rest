require "test_helper"

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

  class BaseModelWithMultipleRelations < Base
    field :corporateIdentificationNumber
    field :name

    relation :baseModelRelations, fields: [:baseModelRelationNumber], multiple: true
  end
end

class BaseModelTest < Minitest::Test
  describe ".attributes" do
    it "list attributes on model" do
      assert_equal %w[corporateIdentificationNumber name], Economic::BaseModel.attributes
    end
  end

  describe ".relations" do
    it "list relations with details on model" do
      assert_equal [{name: "baseModelRelation", fields: [:baseModelRelationNumber], multiple: false}], Economic::BaseModel.relations
    end

    it "can have multiple relations of the same type" do
      assert_equal [{name: "baseModelRelations", fields: [:baseModelRelationNumber], multiple: true}], Economic::BaseModelWithMultipleRelations.relations
    end
  end

  describe "initialize" do
    it "fills in attributes from hash-values" do
      base_model = Economic::BaseModel.new("corporateIdentificationNumber" => 1337)

      assert_equal 1337, base_model.corporate_identification_number
      assert_equal 1337, base_model.corporateIdentificationNumber
    end

    it "creates and populates relations from hash-values" do
      base_model = Economic::BaseModel.new("baseModelRelation" => {"baseModelRelationNumber" => 97_939_393})

      assert_kind_of Economic::BaseModelRelation, base_model.base_model_relation
      assert_equal 97_939_393, base_model.baseModelRelation.base_model_relation_number
      assert_equal 97_939_393, base_model.base_model_relation.base_model_relation_number
    end

    it "is not the same for 2 different base model" do
      base_model = Economic::BaseModel.new("baseModelRelation" => {"baseModelRelationNumber" => 97_939_393})

      base_model2 = Economic::BaseModel.new("baseModelRelation" => {"baseModelRelationNumber" => 97_222})

      refute_equal base_model.base_model_relation, base_model2.base_model_relation
    end

    it "fills in multiple instances of the same relation if multiple is true" do
      base_model = Economic::BaseModelWithMultipleRelations.new("baseModelRelations" => [
        {"baseModelRelationNumber" => 97_939_393},
        {"baseModelRelationNumber" => 97_222},
      ])

      assert_kind_of Array, base_model.base_model_relations
      assert_equal 2, base_model.base_model_relations.size
      assert_equal 97_939_393, base_model.base_model_relations.first.base_model_relation_number
      assert_equal 97_222, base_model.base_model_relations[1].base_model_relation_number
    end

    it "returns an empty array, if a relation, where multiple is true, is not set" do
      base_model = Economic::BaseModelWithMultipleRelations.new

      assert_equal [], base_model.base_model_relations
    end
  end

  describe "to_h" do
    it "returns attributes" do
      h = {"corporateIdentificationNumber" => 1337}
      base_model = Economic::BaseModel.new(h)

      assert_equal h, base_model.to_h
    end

    it "returns relations" do
      h = {"baseModelRelation" => {"baseModelRelationNumber" => 97_939_393}}
      base_model = Economic::BaseModel.new(h)

      assert_equal h, base_model.to_h
    end

    it "only includes relation fields mentioned in relations" do
      h = {"baseModelRelation" => {"baseModelRelationNumber" => 97_939_393, "notInHash" => 4711}}

      base_model = Economic::BaseModel.new(h)

      h_expected = {"baseModelRelation" => {"baseModelRelationNumber" => 97_939_393}}
      assert_equal h_expected, base_model.to_h
    end

    it "handles multiple relations" do
      base_model = Economic::BaseModelWithMultipleRelations.new("baseModelRelations" => [
        {"baseModelRelationNumber" => 97_939_393},
        {"baseModelRelationNumber" => 97_222},
      ])

      h_expected = {"baseModelRelations" => [
        {"baseModelRelationNumber" => 97_939_393},
        {"baseModelRelationNumber" => 97_222},
      ]}
      assert_equal h_expected, base_model.to_h
    end
  end
end
