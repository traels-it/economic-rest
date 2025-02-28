require "test_helper"

module Repos
  class Product < Minitest::Test
    describe Economic::Repos::Product do
      before { set_credentials }

      it "gets all" do
        stub_get_request(endpoint: "products", fixture_name: "products_0")

        products = Economic::Repos::Product.new.all

        assert_equal "01CF8D2E-A6A6-4", products[3].id
        assert_instance_of Economic::Models::Product, products[0]
      end

      it "can update products" do
        product_group = Economic::Models::ProductGroup.new(id: 10)
        product = Economic::Models::Product.new(
          id: "B123",
          name: "awesome toothbrush",
          product_group:
          )
        repo = Economic::Repos::Product.new
        
        repo.expects(:update).with(product)

        repo.update product
      end
    end
  end
end
