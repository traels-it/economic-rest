module Economic
  module Repos
    class Product < Economic::Repo
      def self.in_group(product_group_or_product_group_number)
        id = product_group_or_product_group_number.product_group_number if product_group_or_product_group_number.respond_to? :product_group_number
        id ||= product_group_or_product_group_number

        end_point = [ProductGroupRepo.endpoint_url, id, "products"].join("/")
        response = send_request(method: :get, url: end_point)
        entry_hash = JSON.parse(response.body)
        products = []

        entry_hash["collection"].each do |product|
          products.push Product.new(product)
        end
        products
      end
    end
  end
end
