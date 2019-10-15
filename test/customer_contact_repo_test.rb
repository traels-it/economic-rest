require "test_helper"

class CustomerContactRepoTest < Minitest::Test
  describe "For customer contact" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end

    it "builds the correct endpoint" do
      model = Economic::Customer.new({"name" => "Some customer", "customerNumber" => 12})

      assert_equal "https://restapi.e-conomic.com/customers/12/contacts", Economic::CustomerContactRepo.endpoint_url(model)
    end

    describe "#all" do
      it "finds all customer contacts on a customer" do
        stub_get_request(endpoint: "customers/1/contacts", fixture_name: "customer_contact_0")

        customer = Economic::Customer.new({"name" => "Some customer", "customerNumber" => 1})
        customer_contacts = Economic::CustomerContactRepo.all(on: customer)

        assert_kind_of Economic::CustomerContact, customer_contacts.first
        assert_equal "Simon Testersen", customer_contacts.first.name
      end
    end
  end
end
