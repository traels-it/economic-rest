module Economic
  class PricingRepo < Economic::ProductRepo
    def self.currency_specific_sales_prices_for(entry_number)
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
