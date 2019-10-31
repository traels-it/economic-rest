require "test_helper"

class SessionTest < Minitest::Test
  describe "For product" do
    it "set internal hash and @value for product inside line" do
      line = Economic::Line.new(
        {"description": "desccc",
         "product": Economic::Product.new('productNumber': 23).to_h,
         "quantity": 2,
         "discountPercentage": 0,
         "unit": Economic::Unit.new({"unitNumber": 1}).to_h,
         "unitNetPrice": 1000,}
      )
      assert_equal 23, line.product.productNumber
    end
  end
end
