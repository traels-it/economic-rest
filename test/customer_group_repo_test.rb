require "test_helper"

class CustomerGroupRepoTest < Minitest::Test
  describe "For customer group" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end

    it "gets all" do
      stub_get_request(endpoint: "customer-groups", fixture_name: "customer_groups")

      customer_groups = Economic::CustomerGroupRepo.all

      assert_equal "Danskee", customer_groups[2].to_h["name"]
      assert_kind_of Economic::CustomerGroup, customer_groups[0]
    end
  end
end
