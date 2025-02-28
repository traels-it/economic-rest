require "test_helper"

module Repos
  class Supplier < Minitest::Test
    describe Economic::Repos::Supplier do
      before { set_credentials }

      it "gets all" do
        stub_get_request(endpoint: "suppliers", skippages: 0, fixture_name: "suppliers")

        suppliers = Economic::Repos::Supplier.new.all

        assert_instance_of Economic::Models::Supplier, suppliers.first
        assert_equal 25, suppliers.first.id
        assert_equal 73, suppliers.length
      end

      it "finds based on supplier number" do
        stub_get_request(endpoint: "suppliers", page_or_id: "25", fixture_name: "supplier")

        supplier = Economic::Repos::Supplier.new.find(25)

        assert_instance_of Economic::Models::Supplier, supplier
        assert_equal "Sylvest og Co", supplier.name
      end

      it "can post" do
        stub_request(:post, "https://restapi.e-conomic.com/suppliers")
          .with(
            body: {"currency" => "DKK", :name => "Mr. Anderson", "supplierGroup" => {supplierGroupNumber: 1}, "paymentTerms" => {paymentTermsNumber: 1}, "vatZone" => {vatZoneNumber: 1}}
          ).to_return(status: 200, body: File.read(json_fixture("create_supplier")), headers: {})

        payment_terms = Economic::Models::PaymentTerm.new(payment_terms_number: 1)
        supplier_group = Economic::Models::SupplierGroup.new(id: 1)
        vat_zone = Economic::Models::VatZone.new(vat_zone_number: 1)
        supplier = Economic::Models::Supplier.new(currency: "DKK", name: "Mr. Anderson", payment_terms:, supplier_group:, vat_zone:)

        result = Economic::Repos::Supplier.new.create supplier

        assert_instance_of Economic::Models::Supplier, result
        assert_equal 1, result.id
      end
    end
  end
end
