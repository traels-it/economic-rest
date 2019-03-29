module Economic
  class ProductGroupRepo < Economic::BaseRepo
    def self.find_products(entry_number)
      end_point = [endpoint_url, entry_number, 'products'].join('/')
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
