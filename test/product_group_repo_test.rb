require 'test_helper'

class ProductGroupRepoTest < Minitest::Test
  describe 'For product group' do
    before do
      Economic::Session.authentication('Demo', 'Demo')
    end

    it 'gets all' do
      stub_get_request(endpoint: 'product-groups', fixture_name: 'product_groups')

      product_groups = Economic::ProductGroupRepo.all

      assert_equal 'Ydelser m/moms', product_groups[2].to_h['name']
      assert_kind_of Economic::ProductGroup, product_groups[0]
    end

    it 'gets products in group' do
      stub_request(:get, 'https://restapi.e-conomic.com/product-groups/3/products')
        .to_return(status: 200, body: File.read(json_fixture('products_0')), headers: {})

      products = Economic::ProductGroupRepo.find_products(3)

      assert_equal 'M', products[2].name
      assert_kind_of Economic::Product, products[0]
    end
  end
end
