require "test_helper"

module Economic
  class ResourceTest < Minitest::Test
    class BasicResource < Resource
    end

    class MultipleWordResource < Resource
    end

    class ::Economic::Models::Basic < Model
      field :id
      field :name
    end

    describe Economic::Resource do
      before do
        Economic::Configuration.app_secret_token = "Demo"
        Economic::Configuration.agreement_grant_token = "Demo"
      end

      describe ".new" do
        it "takes a set of credentials" do
          credentials = Economic::Credentials.new(app_secret_token: "Secret", agreement_grant_token: "Grant")

          resource = BasicResource.new(credentials:)

          assert_equal credentials, resource.credentials
        end

        it "raises an error, if given nil credentials" do
          credentials = Economic::Credentials.new(app_secret_token: nil, agreement_grant_token: nil)

          error = assert_raises Economic::MissingCredentialsError do
            BasicResource.new(credentials:)
          end
          assert_equal "Credentials missing! Initialize Economic::BasicResource with a set of credentials or set them on Economic::Configuration", error.message
        end

        it "looks up credentials, if not given any" do
          credentials = Economic::Credentials.new(app_secret_token: "Demo", agreement_grant_token: "Demo")

          resource = BasicResource.new

          assert_equal credentials, resource.credentials
        end

        it "raises an error, if not given any credentials and no credentials have been configured" do
          Economic::Configuration.app_secret_token = nil
          Economic::Configuration.agreement_grant_token = nil

          error = assert_raises Economic::MissingCredentialsError do
            BasicResource.new
          end
          assert_equal "Credentials missing! Initialize Economic::BasicResource with a set of credentials or set them on Economic::Configuration", error.message
        end
      end

      describe "#all" do
        it "sends a get request to the endpoint" do
          stub_request(:get, "https://restapi.e-conomic.com/basics?pagesize=1000&skippages=0").to_return(status: 200, body: {collection: [], pagination: {}, self: "https://restapi.e-conomic.com/basics?pagesize=1000&skippages=0"}.to_json, headers: {})

          BasicResource.new.all
        end

        describe "pagination" do
          it "fetches all pages" do
            stub_request(:get, "https://restapi.e-conomic.com/basics?pagesize=1000&skippages=0").to_return(status: 200, body: {collection: [], pagination: {next_page: "https://restapi.e-conomic.com/basics?pagesize=1000&skippages=1"}, self: "https://restapi.e-conomic.com/basics?pagesize=1000&skippages=0"}.to_json, headers: {})
            stub_request(:get, "https://restapi.e-conomic.com/basics?pagesize=1000&skippages=1").to_return(status: 200, body: {collection: [], pagination: {}, self: "https://restapi.e-conomic.com/basics?pagesize=1000&skippages=1"}.to_json, headers: {})

            BasicResource.new.all
          end
        end

        describe "filtering" do
          it "can filter data on the resource" do
            stub_request(:get, "https://restapi.e-conomic.com/basics?filter=fromDate$gte:2022-01-01&pagesize=1000&skippages=0").to_return(status: 200, body: {collection: [], pagination: {}, self: "https://restapi.e-conomic.com/basics?filter=fromDate$gte:2022-01-01&pagesize=1000&skippages=0"}.to_json, headers: {})

            BasicResource.new.all(filter: "fromDate$gte:#{Date.new(2022, 1, 1)}")
          end
        end
      end

      describe "#find" do
        it "finds a specific record" do
          stub_request(:get, "https://restapi.e-conomic.com/basics/1").to_return(status: 200, body: {id: 1, self: "https://restapi.e-conomic.com/basics/1"}.to_json, headers: {})
          basic = BasicResource.new.find(1)

          assert_equal 1, basic.id
        end
      end

      describe "#create" do
        it "creates a new record" do
          stub_request(:post, "https://restapi.e-conomic.com/basics").to_return(status: 200, body: {id: 2, self: "https://restapi.e-conomic.com/basics/1"}.to_json, headers: {})

          basic = BasicResource.new.create(Economic::Models::Basic.new(id: 2))

          assert_equal 2, basic.id
        end
      end

      describe "#update" do
        it "updates a record" do
          stub_request(:put, "https://restapi.e-conomic.com/basics/2").to_return(status: 200, body: {id: 2, name: "Now with a name", self: "https://restapi.e-conomic.com/basics/1"}.to_json, headers: {})

          model = Models::Basic.new(id: 2, name: "Now with a name")
          updated_model = BasicResource.new.update(model)

          assert_equal "Now with a name", updated_model.name
        end
      end

      describe "#destroy" do
        it "destroys a record" do
          stub_request(:delete, "https://restapi.e-conomic.com/basics/3")
            .to_return(status: 204, body: "", headers: {})

          response = BasicResource.new.destroy(3)

          assert_equal true, response
        end
      end
    end
  end
end
