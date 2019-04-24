module Economic
  class ProductRepo < Economic::BaseRepo
    def self.find_currency_specific_sales_prices(entry_number)
      end_point = [endpoint_url, entry_number, 'pricing', 'currency-specific-sales-prices'].join('/')
      response = test_response(RestClient.get(end_point, headers))
      entry_hash = JSON.parse(response.body)
      pricings = []

      entry_hash['collection'].each do |pricing|
        pricings.push Pricing.new(pricing)
      end
      pricings
    end

    def self.in_group(entry_number)
      end_point = [ProductGroupRepo.endpoint_url, entry_number, 'products'].join('/')
      response = test_response(RestClient.get(end_point, headers))
      entry_hash = JSON.parse(response.body)
      products = []

      entry_hash['collection'].each do |product|
        products.push Product.new(product)
      end
      products
    end
  end
end
