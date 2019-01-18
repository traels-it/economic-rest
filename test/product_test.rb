require 'test_helper'

class ProductTest < Minitest::Test
  describe 'product object' do
    before do
      Economic::Session.authentication('Demo', 'Demo')
    end
    it 'gets all' do
      stub_get_request(endpoint: 'products', fixture_name: 'products_0')

      products = Economic::ProductRepo.all

      assert_equal '01CF8D2E-A6A6-4', products[3].to_h['productNumber']
      assert_kind_of Economic::Product, products[0]
    end

    it 'finds based on customer number' do
      stub_get_request(endpoint: 'products', page_or_id: '01CF8D2E-A6A6-4', fixture_name: 'product')

      product = Economic::ProductRepo.find('01CF8D2E-A6A6-4')

      assert_equal 'fudge', product.to_h['name']
      assert_kind_of Economic::Product, product
    end

    it 'assert no hashes in attributes' do
      stub_get_request(endpoint: 'products', page_or_id: '01CF8D2E-A6A6-4', fixture_name: 'product')

      product = Economic::ProductRepo.find('01CF8D2E-A6A6-4')

      Economic::Product::ATTRIBUTES.each do |att|
        assert false, "#{att} was a hash" if product.send(att).is_a?(Hash)
      end
    end
  end
end
