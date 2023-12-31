module Economic
  class PricingRepo < Economic::ProductRepo
    def self.currency_specific_sales_prices_for(product_or_product_number)
      id = product_or_product_number.product_number if product_or_product_number.respond_to? :product_number
      id ||= product_or_product_number

      id = Economic::BaseRepo.id_to_url_formatted_id(id)
      end_point = [superclass.endpoint_url, id, "pricing", "currency-specific-sales-prices"].join("/")
      response = send_request(method: :get, url: end_point)
      entry_hash = JSON.parse(response.body)
      pricings = []

      entry_hash["collection"].each do |pricing|
        pricings.push Pricing.new(pricing)
      end
      pricings
    end
  end
end
