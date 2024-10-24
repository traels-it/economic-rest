require "test_helper"

class SupplierGroupRepoTest < Minitest::Test
  describe "For supplier" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end

    it "gets all" do
      stub_get_request(endpoint: "supplier-groups", skippages: 0, fixture_name: "supplier_groups")
      supplier_groups = Economic::SupplierGroupRepo.all

      assert_equal 1, supplier_groups[0].supplier_group_number
      assert_equal 1, supplier_groups.length
      assert_kind_of Economic::SupplierGroup, supplier_groups[0]
    end

    it "finds based on supplier group number" do
      stub_get_request(endpoint: "supplier-groups", page_or_id: "1", fixture_name: "supplier_group")

      supplier_group = Economic::SupplierGroupRepo.find(1)

      assert_equal "Diverse", supplier_group.name
      assert_kind_of Economic::SupplierGroup, supplier_group
    end
  end
end
