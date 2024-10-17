require "test_helper"

module Resources
  class CustomerResourceTest < Minitest::Test
    describe Economic::Resources::CustomerResource do
      before { set_credentials }

      it "gets all" do
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
  end
end
