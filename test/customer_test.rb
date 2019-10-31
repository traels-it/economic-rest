require "test_helper"

class CustomerTest < Minitest::Test
  describe "Customer" do
    it "initialize correctly with all relations" do
      assert_equal "eurozone", Economic::Customer.new(
        customerGroup: Economic::CustomerGroup.new,
        vatZone: Economic::VatZone.new(name: "eurozone"),
        paymentTerms: Economic::PaymentTerms.new
      ).vat_zone.name
    end

    it "initialize correctly when its a relation" do
      assert_equal "23", Economic::Order.new(
        customer: Economic::Customer.new(
          customerGroup: Economic::CustomerGroup.new,
          vatZone: Economic::VatZone.new,
          paymentTerms: Economic::PaymentTerms.new
        ),
        paymentTerms: Economic::PaymentTerms.new,
        recipient: Economic::Recipient.new(
          vatZone: Economic::VatZone.new,
          attention: Economic::Attention.new(customerContactNumber: "23")
        )
      ).recipient.attention.customerContactNumber
    end
  end
end
