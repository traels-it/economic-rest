require "test_helper"

class PaymentTermsRepoTest < Minitest::Test
  describe "For payment terms" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end

    it "gets all" do
      stub_get_request(endpoint: "payment-terms", fixture_name: "payment_terms")

      payment_terms = Economic::PaymentTermsRepo.all

      assert_equal "Til omgående betaling", payment_terms[2].to_h["name"]
      assert_kind_of Economic::PaymentTerms, payment_terms[0]
    end
  end
end
