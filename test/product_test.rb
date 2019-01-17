require 'test_helper'

class ProductTest < Minitest::Test
  describe 'product object' do
    before do
      Economic::Session.authentication('Demo', 'Demo')
    end
    it 'gets all' do
      stub_get_request('products', '', 'products')

      products = Economic::ProductRepo.all

      assert_equal '01CF8D2E-A6A6-4', products[3].to_h['productNumber']
    end

    it 'finds based on customer number' do
      stub_get_request('products', '01CF8D2E-A6A6-4', 'product')

      product = Economic::ProductRepo.find('01CF8D2E-A6A6-4')

      assert_equal 'fudge', product.to_h['name']
    end
  end
end
