require "test_helper"

module Economic
  class BaseModelRelation < Model
    field :base_model_relation_number
    field :not_in_hash
  end

  class BaseModel < Model
    field :id, as: :corporateIdentificationNumber
    field :name

    relation :base_model_relation, fields: [:base_model_relation_number]
  end

  class BaseModelWithMultipleRelations < Model
    field :corporate_identification_number
    field :name

    relation :base_model_relations, fields: [:base_model_relation_number], multiple: true
  end
end

class BaseModelTest < Minitest::Test
  describe ".attributes" do
    it "list attributes on model" do
      expected_result = [
        Economic::Attribute.new(name: :id, as: :corporateIdentificationNumber),
        Economic::Attribute.new(name: :name, as: nil)
      ]

      assert_equal expected_result, Economic::BaseModel.attributes
    end
  end

  describe ".relations" do
    it "list relations with details on model" do
      expected_result = [Economic::Relation.new(name: :base_model_relation, fields: [:base_model_relation_number], as: nil, multiple: false)]

      assert_equal expected_result, Economic::BaseModel.relations
    end

    it "relations can be multiple" do
      expected_result = [Economic::Relation.new(name: :base_model_relations, fields: [:base_model_relation_number], as: nil, multiple: true)]

      assert_equal expected_result, Economic::BaseModelWithMultipleRelations.relations
    end
  end

  describe ".from_json" do
    it "initializes an instance from a JSON string" do
      base_model = Economic::BaseModel.from_json('{"corporateIdentificationNumber":1337}')

      assert_equal 1337, base_model.id
    end

    it "creates and populates relations from JSON strings" do
      base_model = Economic::BaseModel.from_json('{"baseModelRelation":{"baseModelRelationNumber":97939393}}')

      assert_kind_of Economic::BaseModelRelation, base_model.base_model_relation
      assert_equal 97_939_393, base_model.base_model_relation.base_model_relation_number
    end

    it "is not the same for 2 different base models" do
      base_model = Economic::BaseModel.from_json('{"baseModelRelation":{"baseModelRelationNumber":97939393}}')

      base_model2 = Economic::BaseModel.from_json('{"baseModelRelation":{"baseModelRelationNumber":97222}}')

      refute_equal base_model.base_model_relation, base_model2.base_model_relation
    end

    it "has multiple instances of the same relation if multiple is true" do
      base_model = Economic::BaseModelWithMultipleRelations.from_json('{"baseModelRelations":[
        {"baseModelRelationNumber":97939393},
        {"baseModelRelationNumber":97222}
      ]}')

      assert_kind_of Array, base_model.base_model_relations
      assert_equal 2, base_model.base_model_relations.size
      assert_equal 97_939_393, base_model.base_model_relations.first.base_model_relation_number
      assert_equal 97_222, base_model.base_model_relations[1].base_model_relation_number
    end

    it "returns an empty array, if a relation, where multiple is true, is not set" do
      base_model = Economic::BaseModelWithMultipleRelations.from_json("{}")

      assert_equal [], base_model.base_model_relations
    end
  end

  describe "assignment" do
    it "assigns attributes" do
      base_model = Economic::BaseModel.new

      base_model.name = "floe"

      assert_equal "floe", base_model.name
    end

    it "assigns relations" do
      base_model = Economic::BaseModel.new
      rel = Economic::BaseModelRelation.new

      base_model.base_model_relation = rel

      assert_equal rel, base_model.base_model_relation
    end

    it "assigns relations for models with multiple relations" do
      base_model = Economic::BaseModelWithMultipleRelations.new
      rel = Economic::BaseModelRelation.new

      base_model.base_model_relations = [rel, Economic::BaseModelRelation.new]

      assert_equal rel, base_model.base_model_relations.first
    end
  end

  describe "initialization" do
    it "raises an ArgumentError if given a positional argument" do
      error = assert_raises do
        Economic::BaseModel.new("not_a_keyword_argument")
      end
      assert_equal "wrong number of arguments (given 1, expected 0)", error.message
    end

    it "raises an error, if given a keyword argument not in attributes or relations" do
      error = assert_raises do
        Economic::BaseModel.new(unknown_attribute: "hello", name: "Name")
      end
      assert_equal "invalid keys: unknown_attribute", error.message
    end
  end

  describe "#to_json" do
    it "renders attributes" do
      expected_result = {"corporateIdentificationNumber" => 1337}.to_json
      base_model = Economic::BaseModel.new(id: 1337)

      assert_equal expected_result, base_model.to_json
    end

    it "renders relations" do
      expected_result = {"baseModelRelation" => {"baseModelRelationNumber" => 97_939_393}}.to_json
      base_model = Economic::BaseModel.new(base_model_relation: Economic::BaseModelRelation.new(base_model_relation_number: 97_939_393))

      assert_equal expected_result, base_model.to_json
    end

    it "only renders relation fields mentioned in relations" do
      skip "Is this even an issue? An if it is, why?"
      h = {"baseModelRelation" => {"baseModelRelationNumber" => 97_939_393, "notInHash" => 4711}}

      base_model = Economic::BaseModel.new(h)

      h_expected = {"baseModelRelation" => {"baseModelRelationNumber" => 97_939_393}}
      assert_equal h_expected, base_model.to_json
    end

    it "handles multiple relations" do
      expected_result = {"baseModelRelations" => [
        {"baseModelRelationNumber" => 97_939_393},
        {"baseModelRelationNumber" => 97_222}
      ]}.to_json

      base_model_relations = [
        Economic::BaseModelRelation.new(base_model_relation_number: 97_939_393),
        Economic::BaseModelRelation.new(base_model_relation_number: 97_222)
      ]
      model = Economic::BaseModelWithMultipleRelations.new(base_model_relations:)

      assert_equal expected_result, model.to_json
    end

    it "only includes a multiple relation in the hash, when the relation has values" do
      expected_result = {}.to_json

      base_model = Economic::BaseModelWithMultipleRelations.new(base_model_relations: [])

      assert_equal(expected_result, base_model.to_json)
    end
  end
end
