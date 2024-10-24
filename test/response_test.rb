require "test_helper"

class ResponseTest < Minitest::Test
  describe ".from_json" do
    it "builds a pagination object" do
      json = File.read(json_fixture("customers_0"))

      response = Economic::Response.from_json(json)

      assert_instance_of Economic::Response::Pagination, response.pagination
    end

    it "stores the collection data" do
      json = File.read(json_fixture("customers_0"))

      response = Economic::Response.from_json(json)

      assert_instance_of Array, response.collection
    end

    it "builds an entity, when json has no collection key" do
      json = File.read(json_fixture("customer"))

      response = Economic::Response.from_json(json)

      assert_instance_of Economic::Models::Customer, response.entity
    end
  end
end
