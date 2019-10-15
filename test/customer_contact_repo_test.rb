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

    describe "#send" do
      it "can create a customer contact" do
        stub_get_request(endpoint: "customers/1/contacts", nested: true, fixture_name: "customer_contact_send", method: :post)

        customer = Economic::Customer.new({"name" => "Some customer", "customerNumber" => 1})
        contact = Economic::CustomerContact.new({"name" => "Torsten Test"})
        result = Economic::CustomerContactRepo.send(contact, on: customer)

        assert_kind_of Economic::CustomerContact, result
        assert_equal "Torsten Test", result.name
        refute_nil result.id_key
      end
    end

    describe "#save" do
      it "can create a customer contact" do
        stub_get_request(endpoint: "customers/1/contacts/", nested: true, fixture_name: "customer_contact_send", method: :post)

        customer = Economic::Customer.new({"name" => "Some customer", "customerNumber" => 1})
        contact = Economic::CustomerContact.new({"name" => "Torsten Test"})
        result = Economic::CustomerContactRepo.save(contact, on: customer)

        assert_kind_of Economic::CustomerContact, result
        assert_equal "Torsten Test", result.name
        refute_nil result.id_key
      end

      it "can update an existing customer contact" do
        stub_get_request(endpoint: "customers/1/contacts/325", nested: true, fixture_name: "customer_contact", method: :put)

        customer = Economic::Customer.new({"name" => "Some customer", "customerNumber" => 1})
        contact = Economic::CustomerContact.new({"name" => "Torsten Torsten", "customerContactNumber" => 325})
        result = Economic::CustomerContactRepo.save(contact, on: customer)

        assert_kind_of Economic::CustomerContact, result
        assert_equal "Torsten Torsten", result.name
        assert_equal 325, result.id_key
      end
    end

    describe "#find" do
      it "can find a single customer contact by its id" do
        stub_get_request(endpoint: "customers/1/contacts/325", nested: true, fixture_name: "customer_contact", method: :get)

        customer = Economic::Customer.new({"name" => "Some customer", "customerNumber" => 1})
        result = Economic::CustomerContactRepo.find(325, on: customer)

        assert_kind_of Economic::CustomerContact, result
        assert_equal "Torsten Torsten", result.name
        assert_equal 325, result.id_key
      end
    end

    describe "#filter" do
      it "can filter the customer contacts" do
        stub_get_request(endpoint: "customers/1/contacts?filter=name$like:Torsten&pagesize=1000&skippages=0", nested: true, fixture_name: "customer_contact_filter", method: :get)

        customer = Economic::Customer.new({"name" => "Some customer", "customerNumber" => 1})
        result = Economic::CustomerContactRepo.filter("name$like:Torsten", on: customer)

        assert_kind_of Economic::CustomerContact, result.first
        assert_equal "Torsten Test", result.first.name
      end
    end
  end
end
