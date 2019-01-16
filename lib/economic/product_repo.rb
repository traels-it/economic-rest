module Economic
  class ProductRepo < Economic::BaseRepo
    def self.all
      response = fetch('products', '')
      products_hash = JSON.parse(response.body)['collection']
      products = []

      products_hash.each do |hash|
        products.push Economic::Product.new(hash)
      end
      products
    end

    def self.find(product_number)
      response = fetch('products', product_number)
      hash = JSON.parse(response.body)
      Economic::Product.new(hash)
    end
  end
end
