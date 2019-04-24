module Economic
  class PricingRepo < Economic::ProductRepo
    def self.currency_specific_sales_prices_for(product_or_produduct_number)
      entry_number = product_or_produduct_number
      entry_number = entry_number.product_number if entry_number.class.method_defined? :product_number

      end_point = [superclass.endpoint_url, entry_number, 'pricing', 'currency-specific-sales-prices'].join('/')
      response = test_response(RestClient.get(end_point, headers))
      entry_hash = JSON.parse(response.body)
      pricings = []

      entry_hash['collection'].each do |pricing|
        pricings.push Pricing.new(pricing)
      end
      pricings
    end
  end
end