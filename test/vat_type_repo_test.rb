require "test_helper"

class VatTypeRepoTest < Minitest::Test
  describe "For vat type" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end

    it "gets all" do
      stub_get_request(endpoint: "vat-types", fixture_name: "vat_types")

      vat_types = Economic::VatTypeRepo.all

      assert_equal "Reversed charge", vat_types[2].to_h["name"]
      assert_kind_of Economic::VatType, vat_types[0]
    end
  end
end
