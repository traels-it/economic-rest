module Economic
  class ProductRepo < Economic::BaseRepo
    def self.in_group(product_group_or_product_group_number)
      id = product_group_or_product_group_number.product_group_number if product_group_or_product_group_number.respond_to? :product_group_number
      id ||= product_group_or_product_group_number

      end_point = [ProductGroupRepo.endpoint_url, id, 'products'].join('/')
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
