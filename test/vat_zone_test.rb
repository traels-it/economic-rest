require "test_helper"

class VatZoneTest < Minitest::Test
  describe "For vat zone" do
    it "initialize correctly from hash values" do
      assert_equal "eurozone", Economic::VatZone.new(name: "eurozone").name
    end
  end
end
