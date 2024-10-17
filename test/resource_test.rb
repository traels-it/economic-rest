require "test_helper"

module Economic
  class ResourceTest < Minitest::Test
    class BasicResource < Resource
    end

    class MultipleWordResource < Resource
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

      describe "headers" do
        it "sets the headers from the credentials" do
          credentials = Economic::Credentials.new(app_secret_token: "Demo", agreement_grant_token: "Demo")
          expected_result = {'X-AppSecretToken': "Demo", 'X-AgreementGrantToken': "Demo", 'Content-Type': "application/json"}

          resource = BasicResource.new(credentials:)

          assert_equal expected_result, resource.headers
        end
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
end
