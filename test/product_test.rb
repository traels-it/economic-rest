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

    it 'returns json data based on changes to the model' do
      stub_get_request(endpoint: 'products', page_or_id: '01CF8D2E-A6A6-4', fixture_name: 'product')

      product = Economic::ProductRepo.find('01CF8D2E-A6A6-4')

      assert product.to_h.inspect.include? 'fudge'
    end

    it 'saves' do
      stub_request(:get, 'https://restapi.e-conomic.com/products/100023').to_return(status: 200, body: '{"productNumber":"100023","description":"Flexel 260x85/3.00-4 blok grå","name":"Flexel 260x85/3.00-4 blok grå","costPrice":138.00,"recommendedPrice":490.50,"salesPrice":487.50,"barred":false,"lastUpdated":"2019-01-22T11:53:00Z","productGroup":{"productGroupNumber":100,"name":"BEK test 100","salesAccounts":"https://restapi.e-conomic.com/product-groups/100/sales-accounts","products":"https://restapi.e-conomic.com/product-groups/100/products","self":"https://restapi.e-conomic.com/product-groups/100"},"invoices":{"drafts":"https://restapi.e-conomic.com/products/100023/invoices/drafts","booked":"https://restapi.e-conomic.com/products/100023/invoices/booked","self":"https://restapi.e-conomic.com/products/100023/invoices"},"pricing":{"currencySpecificSalesPrices":"https://restapi.e-conomic.com/products/100023/pricing/currency-specific-sales-prices"},"metaData":{"delete":{"description":"Delete this product.","href":"https://restapi.e-conomic.com/products/100023","httpMethod":"delete"},"replace":{"description":"Replace this product.","href":"https://restapi.e-conomic.com/products/100023","httpMethod":"put"}},"self":"https://restapi.e-conomic.com/products/100023"}', headers: {})

      stub_request(:put, 'https://restapi.e-conomic.com/products/100023').to_return(status: 200, body: '{"productNumber":"100023","description":"Flexel 260x85/3.00-4 blok grå","name":"Flexel 260x85/3.00-4 blok grå","costPrice":138.00,"recommendedPrice":491.50,"salesPrice":487.50,"barred":false,"lastUpdated":"2019-01-22T11:56:00Z","productGroup":{"productGroupNumber":100,"name":"BEK test 100","salesAccounts":"https://restapi.e-conomic.com/product-groups/100/sales-accounts","products":"https://restapi.e-conomic.com/product-groups/100/products","self":"https://restapi.e-conomic.com/product-groups/100"},"invoices":{"drafts":"https://restapi.e-conomic.com/products/100023/invoices/drafts","booked":"https://restapi.e-conomic.com/products/100023/invoices/booked","self":"https://restapi.e-conomic.com/products/100023/invoices"},"pricing":{"currencySpecificSalesPrices":"https://restapi.e-conomic.com/products/100023/pricing/currency-specific-sales-prices"},"metaData":{"delete":{"description":"Delete this product.","href":"https://restapi.e-conomic.com/products/100023","httpMethod":"delete"},"replace":{"description":"Replace this product.","href":"https://restapi.e-conomic.com/products/100023","httpMethod":"put"}},"self":"https://restapi.e-conomic.com/products/100023"}', headers: {})

      product = Economic::ProductRepo.find('100023')
      new_price = product.recommendedPrice + 1

      product.recommendedPrice = new_price
      product.save

      assert_equal new_price, product.recommended_price
    end
  end
end
