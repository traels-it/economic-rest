require "test_helper"

module Economic
  class ResourceTest < Minitest::Test
    class BasicResource < Resource
    end

    class MultipleWordResource < Resource
    end

    describe "#endpoint" do
      it "builds an endpoint url for a resource" do
        assert_equal "basics", BasicResource.new.endpoint
      end
      
      it "handles endpoints with multiple words" do
        assert_equal "multiple-words", MultipleWordResource.new.endpoint
      end
    end

    describe "#all" do
      it "sends a get request to the endpoint" do
        stub_request(:get, "https://restapi.e-conomic.com/basics?pagesize=1000&skippages=0").to_return(status: 200, body: {collection: []}.to_json, headers: {})
        
        BasicResource.new.all
      end
    end
  end
end
