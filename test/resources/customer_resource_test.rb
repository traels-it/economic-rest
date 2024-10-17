require "test_helper"

module Resources
  class CustomerResourceTest < Minitest::Test
    describe Economic::Resources::CustomerResource do
      before { set_credentials }

      describe "#all" do
        it "returns all customers" do
          stub_get_request(endpoint: "customers", skippages: 0, fixture_name: "customers_0")
          stub_get_request(endpoint: "customers", skippages: 1, fixture_name: "customers_1")
          stub_get_request(endpoint: "customers", skippages: 2, fixture_name: "customers_2")
          stub_get_request(endpoint: "customers", skippages: 3, fixture_name: "customers_3")

          customers = Economic::Resources::CustomerResource.new.all
          customer = customers.first

          assert_kind_of Economic::Models::Customer, customer
          assert_equal 1, customer.id
          assert_equal 3684, customers.length
        end
      end

      describe "#find" do
        it "finds based on customer number" do
          stub_get_request(endpoint: "customers", page_or_id: "1", fixture_name: "customer")

          customer = Economic::Resources::CustomerResource.new.find(1)

          assert_kind_of Economic::Models::Customer, customer
          assert_equal 1, customer.id
          assert_equal "aaaa@aaa.com", customer.email
        end

        it "finds from customer instance" do
          stub_get_request(endpoint: "customers", page_or_id: "1", fixture_name: "customer")

          customer = Economic::Resources::CustomerResource.new.find(Economic::Models::Customer.new(id: 1))

          assert_kind_of Economic::Models::Customer, customer
          assert_equal 1, customer.id
          assert_equal "aaaa@aaa.com", customer.email
        end
      end

      describe "#create" do
        it "creates a new customer" do
          stub_request(:post, "https://restapi.e-conomic.com/customers")
            .with(
              body: {currency: "DKK", name: "Mr. Anderson", customerGroup: {customerGroupNumber: 1}, paymentTerms: {paymentTermsNumber: 1}, vatZone: {vatZoneNumber: 1}}
            ).to_return(status: 200, body: File.read(json_fixture("create_customer")), headers: {})

          customer = Economic::Models::Customer.new(
            currency: "DKK",
            name: "Mr. Anderson",
            customer_group: Economic::Models::CustomerGroup.new(id: 1),
            vat_zone: Economic::Models::VatZone.new(vat_zone_number: 1),
            payment_terms: Economic::Models::PaymentTerm.new(payment_terms_number: 1)
          )

          result = Economic::Resources::CustomerResource.new.create(customer)

          assert_instance_of Economic::Models::Customer, result
          assert_equal 974994345, result.id
        end
      end
    end
  end
end
