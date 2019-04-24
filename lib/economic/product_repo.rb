module Economic
  class ProductRepo < Economic::BaseRepo
    def self.in_group(product_group_or_product_group_number)
      entry_number = product_group_or_product_group_number
      entry_number = entry_number.product_group_number if entry_number.class.method_defined? :product_group_number
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
