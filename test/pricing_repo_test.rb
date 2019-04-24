require 'test_helper'

class PricingRepoTest < Minitest::Test
  describe 'For product' do
    before do
      Economic::Session.authentication('Demo', 'Demo')
    end

    it 'can get currency_specific_sales_prices' do
      stub_request(:get, 'https://restapi.e-conomic.com/products/90003/pricing/currency-specific-sales-prices')
        .to_return(status: 200, body: File.read(json_fixture('pricings')), headers: {})

      pricings = Economic::PricingRepo.currency_specific_sales_prices_for(90_003)
      assert_equal Economic::Pricing, pricings.first.class
      assert_equal 'EUR', pricings.first.currency.code
      assert_equal 10.0, pricings.first.price
      assert_equal '90003', pricings.first.product.product_number
    end
  end
end
