require "test_helper"

class SupplierRepoTest < Minitest::Test
  describe "For supplier" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end

    it "gets all" do
      stub_get_request(endpoint: "suppliers", skippages: 0, fixture_name: "suppliers")

      suppliers = Economic::SupplierRepo.all

      assert_equal 25, suppliers[0].to_h["supplierNumber"]
      assert_equal 73, suppliers.length
      assert_kind_of Economic::Supplier, suppliers[0]
    end

    it "finds based on supplier number" do
      stub_get_request(endpoint: "suppliers", page_or_id: "25", fixture_name: "supplier")

      supplier = Economic::SupplierRepo.find(25)

      assert_equal "Sylvest og Co", supplier.to_h["name"]
      assert_kind_of Economic::Supplier, supplier
    end

    it "can post" do
      stub_request(:post, "https://restapi.e-conomic.com/suppliers")
        .with(
          body: {"currency" => "DKK", :name => "Mr. Anderson", "supplierGroup" => {supplierGroupNumber: 1}, "paymentTerms" => {paymentTermsNumber: 1}, "vatZone" => {vatZoneNumber: 1}}
        ).to_return(status: 200, body: "", headers: {})

      supplier = Economic::Supplier.new({})
      supplier.currency = "DKK"
      supplier.supplier_group.supplier_group_number = 1
      supplier.vat_zone.vat_zone_number = 1
      supplier.name = "Mr. Anderson"
      supplier.payment_terms.payment_terms_number = 1

      assert Economic::SupplierRepo.save supplier
    end
  end
end
