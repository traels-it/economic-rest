require "test_helper"

module Repos
  class CustomerTest < Minitest::Test
    describe Economic::Repos::Customer do
      before { set_credentials }

      describe "#all" do
        it "returns all customers" do
          stub_get_request(endpoint: "customers", skippages: 0, fixture_name: "customers_0")
          stub_get_request(endpoint: "customers", skippages: 1, fixture_name: "customers_1")
          stub_get_request(endpoint: "customers", skippages: 2, fixture_name: "customers_2")
          stub_get_request(endpoint: "customers", skippages: 3, fixture_name: "customers_3")

          customers = Economic::Repos::Customer.new.all
          customer = customers.first

          assert_kind_of Economic::Models::Customer, customer
          assert_equal 1, customer.id
          assert_equal 3684, customers.length
        end
      end

      describe "#find" do
        it "finds based on customer number" do
          stub_get_request(endpoint: "customers", page_or_id: "1", fixture_name: "customer")

          customer = Economic::Repos::Customer.new.find(1)

          assert_kind_of Economic::Models::Customer, customer
          assert_equal 1, customer.id
          assert_equal "aaaa@aaa.com", customer.email
        end

        it "finds from customer instance" do
          stub_get_request(endpoint: "customers", page_or_id: "1", fixture_name: "customer")

          customer = Economic::Repos::Customer.new.find(Economic::Models::Customer.new(id: 1))

          assert_kind_of Economic::Models::Customer, customer
          assert_equal 1, customer.id
          assert_equal "aaaa@aaa.com", customer.email
        end

        it "raises a NotFoundError, when not finding customer with the supplied id" do
          expected_result = File.read(json_fixture("404"))
          stub_request(:get, "https://restapi.e-conomic.com/customers/10000000000")
            .to_return(status: 404, body: expected_result, headers: {})

          error = assert_raises Economic::NotFoundError do
            Economic::Repos::Customer.new.find(10000000000)
          end
          assert_equal expected_result, error.message
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

          result = Economic::Repos::Customer.new.create(customer)

          assert_instance_of Economic::Models::Customer, result
          assert_equal 974994345, result.id
        end
      end

      describe "#update" do
        it "can update a customer" do
          stub_request(:put, "https://restapi.e-conomic.com/customers/974994344")
            .with(
              body: {customerNumber: 974994344, currency: "DKK", name: "A new name", customerGroup: {customerGroupNumber: 1}, paymentTerms: {paymentTermsNumber: 1}, vatZone: {vatZoneNumber: 1}}
            ).to_return(status: 200, body: File.read(json_fixture("update_customer")), headers: {})

          customer = Economic::Models::Customer.new(
            id: 974994344,
            currency: "DKK",
            name: "A new name",
            customer_group: Economic::Models::CustomerGroup.new(id: 1),
            vat_zone: Economic::Models::VatZone.new(vat_zone_number: 1),
            payment_terms: Economic::Models::PaymentTerm.new(payment_terms_number: 1)
          )

          updated_customer = Economic::Repos::Customer.new.update(customer)

          assert_instance_of Economic::Models::Customer, updated_customer
          assert_equal "A new name", updated_customer.name
        end
      end

      describe "#destroy" do
        it "can destroy a customer from id" do
          stub_request(:delete, "https://restapi.e-conomic.com/customers/974994345")
            .to_return(status: 204, body: "", headers: {})

          result = Economic::Repos::Customer.new.destroy(974994345)

          assert_equal true, result
        end

        it "can destroy a customer from a model" do
          stub_request(:delete, "https://restapi.e-conomic.com/customers/974994345")
            .to_return(status: 204, body: "", headers: {})

          result = Economic::Repos::Customer.new.destroy(Economic::Models::Customer.new(id: 974994345))

          assert_equal true, result
        end
      end
    end
  end
end
