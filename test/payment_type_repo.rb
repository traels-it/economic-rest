require "test_helper"

class PaymentTypeRepoTest < Minitest::Test
  describe "For payment_type" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end

    it "gets all" do
      stub_get_request(endpoint: "payment-types", pageindex: 0, fixture_name: "payment_types")

      payment_types = Economic::PaymentTypeRepo.all

      assert_equal 7, payment_types.size
      assert_equal "+71", payment_types.first.name
      assert_equal 1, payment_types.first.payment_type_number
    end

    it "finds based on paymentTypeNumber" do
      stub_get_request(endpoint: "payment.types", page_or_id: "7", fixture_name: "payment_type")

      payment_type = Economic::PaymentTypeRepo.find(7)

      assert_equal "Bank transfer", payment_type.name
      assert_equal 7, payment_type.payment_type_number
      assert_kind_of Economic::PaymentType, payment_type
    end
  end
end
