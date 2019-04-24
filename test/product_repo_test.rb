require 'test_helper'

class ProductRepoTest < Minitest::Test
  describe 'For product' do
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

    it 'returns json data based on changes to the model' do
      stub_get_request(endpoint: 'products', page_or_id: '01CF8D2E-A6A6-4', fixture_name: 'product')

      product = Economic::ProductRepo.find('01CF8D2E-A6A6-4')

      assert product.to_h.inspect.include? 'fudge'
    end

    it 'can post' do
      stub_request(:post, 'https://restapi.e-conomic.com/products')
        .with(body: { "name": 'awesome toothbrush', "productNumber": 'B123', "productGroup": { "productGroupNumber": 10 } }).to_return(status: 200, body: '', headers: {})

      p = Economic::Product.new({})
      p.product_number = 'B123'
      p.name = 'awesome toothbrush'
      p.product_group.product_group_number = 10

      assert Economic::ProductRepo.send p
    end

    it 'can get currency_specific_sales_prices' do
      stub_request(:get, 'https://restapi.e-conomic.com/products/90003/pricing/currency-specific-sales-prices')
        .to_return(status: 200, body: File.read(json_fixture('pricings')), headers: {})

      pricings = Economic::ProductRepo.find_currency_specific_sales_prices(90_003)
      assert_equal Economic::Pricing, pricings.first.class
      assert_equal 'EUR', pricings.first.currency.code
      assert_equal 10.0, pricings.first.price
      assert_equal '90003', pricings.first.product.product_number
    end

    it 'gets products in group' do
      stub_request(:get, 'https://restapi.e-conomic.com/product-groups/3/products')
        .to_return(status: 200, body: File.read(json_fixture('products_0')), headers: {})

      products = Economic::ProductRepo.in_group(3)

      assert_equal 'M', products[2].name
      assert_kind_of Economic::Product, products[0]
    end
  end
end
