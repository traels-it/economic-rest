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
    end
  end
end
