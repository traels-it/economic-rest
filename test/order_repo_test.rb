require 'test_helper'

class OrderRepoTest < Minitest::Test
  describe 'order object' do
    before do
      Economic::Session.authentication('Demo', 'Demo')
    end
    it 'gets all' do
      stub_get_request(endpoint: 'orders/archived', fixture_name: 'orders_archived')
      stub_get_request(endpoint: 'orders/drafts', fixture_name: 'orders_drafts')
      stub_get_request(endpoint: 'orders/sent', fixture_name: 'orders_sent')

      orders_archived = Economic::Orders::ArchivedRepo.all
      orders_drafts = Economic::Orders::DraftsRepo.all
      orders_sent = Economic::Orders::SentRepo.all

      assert_equal 35_072, orders_archived[1].to_h['orderNumber']
      assert_equal 35_070, orders_drafts[0].to_h['orderNumber']
      assert_equal 35_071, orders_sent[0].to_h['orderNumber']
      assert_kind_of Economic::Order, orders_archived[0]
      assert_kind_of Economic::Order, orders_drafts[0]
      assert_kind_of Economic::Order, orders_sent[0]
    end

    it 'finds based on order number' do
      stub_get_request(endpoint: 'orders/archived', page_or_id: '35072', fixture_name: 'orders_archived_one')
      stub_get_request(endpoint: 'orders/drafts', page_or_id: '35070', fixture_name: 'orders_drafts_one')
      stub_get_request(endpoint: 'orders/sent', page_or_id: '35071', fixture_name: 'orders_sent_one')

      orders_archived_one = Economic::Orders::ArchivedRepo.find(35_072)
      orders_drafts_one = Economic::Orders::DraftsRepo.find(35_070)
      orders_sent_one = Economic::Orders::SentRepo.find(35_071)

      assert_equal 18_187.50, orders_archived_one.to_h['grossAmountInBaseCurrency']
      assert_equal 1000, orders_drafts_one.to_h['grossAmountInBaseCurrency']
      assert_equal 1100, orders_sent_one.to_h['grossAmountInBaseCurrency']
      assert_kind_of Economic::Order, orders_archived_one
      assert_kind_of Economic::Order, orders_drafts_one
      assert_kind_of Economic::Order, orders_sent_one
    end

    it 'returns json data based on changes to the model' do
      stub_get_request(endpoint: 'orders/archived', page_or_id: '35072', fixture_name: 'orders_archived_one')
      orders_archived_one = Economic::Orders::ArchivedRepo.find(35_072)

      orders_archived_one.due_date = '2019-12-24'

      assert orders_archived_one.to_h.inspect.include? '2019-12-24'
    end
    it 'pulls a sent order back to draft and back to sent' do
      stub_request(:get, 'https://restapi.e-conomic.com/orders/sent/15')
        .to_return(status: 200, body: '{"orderNumber":15,"templates":{"upgradeInstructions":"https://restapi.e-conomic.com/orders/sent/15/templates/upgrade-instructions/draftInvoice","self":"https://restapi.e-conomic.com/orders/sent/15/templates"},"soap":{"orderHandle":{"id":45}},"attachment":"https://restapi.e-conomic.com/orders/sent/15/attachment","lines":[{"lineNumber":1,"sortKey":1,"description":"Sidespejl (Sæt) Karma","product":{"productNumber":"100082","self":"https://restapi.e-conomic.com/products/100082"},"quantity":1.00,"unitNetPrice":250.00,"discountPercentage":0.00,"unitCostPrice":50.03,"totalNetAmount":250.00,"marginInBaseCurrency":199.97,"marginPercentage":79.99},{"lineNumber":2,"sortKey":2,"description":"Øvre Stokkeholder Mc","product":{"productNumber":"67","self":"https://restapi.e-conomic.com/products/67"},"quantity":1.00,"unitNetPrice":450.00,"discountPercentage":0.00,"unitCostPrice":0.00,"totalNetAmount":450.00,"marginInBaseCurrency":450.00,"marginPercentage":100.00}],"date":"2017-01-13","currency":"DKK","exchangeRate":100.000000,"netAmount":700.000000,"netAmountInBaseCurrency":700.00,"grossAmount":875.00,"grossAmountInBaseCurrency":875.00,"marginInBaseCurrency":649.97,"marginPercentage":92.85,"vatAmount":175.000000,"roundingAmount":0.00,"costPriceInBaseCurrency":50.0300,"dueDate":"2017-03-02","paymentTerms":{"paymentTermsNumber":2,"daysOfCredit":30,"name":"Løbende måned 30 dage","paymentTermsType":"invoiceMonth","self":"https://restapi.e-conomic.com/payment-terms/2"},"customer":{"customerNumber":10001,"self":"https://restapi.e-conomic.com/customers/10001"},"recipient":{"name":"Æblegrød","address":"Bøgevej 32","zip":"5200","city":"Odense V","country":"DK","vatZone":{"vatZoneNumber":1,"self":"https://restapi.e-conomic.com/vat-zones/1"},"nemHandelType":"ean"},"layout":{"layoutNumber":16,"self":"https://restapi.e-conomic.com/layouts/16"},"pdf":{"download":"https://restapi.e-conomic.com/orders/sent/15/pdf"},"self":"https://restapi.e-conomic.com/orders/sent/15"}', headers: {})
      stub_request(:post, 'https://restapi.e-conomic.com//orders/drafts')
        .with(body: '{"orderNumber":15,"templates":{"upgradeInstructions":"https://restapi.e-conomic.com/orders/sent/15/templates/upgrade-instructions/draftInvoice","self":"https://restapi.e-conomic.com/orders/sent/15/templates","upgrade_instructions":"https://restapi.e-conomic.com/orders/sent/15/templates/upgrade-instructions/draftInvoice"},"soap":{"orderHandle":{"id":45}},"attachment":"https://restapi.e-conomic.com/orders/sent/15/attachment","lines":[{"lineNumber":1,"sortKey":1,"description":"Sidespejl (Sæt) Karma","product":{"productNumber":"100082","self":"https://restapi.e-conomic.com/products/100082"},"quantity":1.0,"unitNetPrice":250.0,"discountPercentage":0.0,"unitCostPrice":50.03,"totalNetAmount":250.0,"marginInBaseCurrency":199.97,"marginPercentage":79.99},{"lineNumber":2,"sortKey":2,"description":"Øvre Stokkeholder Mc","product":{"productNumber":"67","self":"https://restapi.e-conomic.com/products/67"},"quantity":1.0,"unitNetPrice":450.0,"discountPercentage":0.0,"unitCostPrice":0.0,"totalNetAmount":450.0,"marginInBaseCurrency":450.0,"marginPercentage":100.0}],"date":"2017-01-13","currency":"DKK","exchangeRate":100.0,"netAmount":700.0,"netAmountInBaseCurrency":700.0,"grossAmount":875.0,"grossAmountInBaseCurrency":875.0,"marginInBaseCurrency":649.97,"marginPercentage":92.85,"vatAmount":175.0,"roundingAmount":0.0,"costPriceInBaseCurrency":50.03,"dueDate":"2017-03-02","paymentTerms":{"paymentTermsNumber":2,"daysOfCredit":30,"name":"Løbende måned 30 dage","paymentTermsType":"invoiceMonth","self":"https://restapi.e-conomic.com/payment-terms/2","payment_terms_number":2,"days_of_credit":30,"payment_terms_type":"invoiceMonth"},"customer":{"customerNumber":10001,"self":"https://restapi.e-conomic.com/customers/10001","customer_number":10001},"recipient":{"name":"Æblegrød","address":"Bøgevej 32","zip":"5200","city":"Odense V","country":"DK","vatZone":{"vatZoneNumber":1,"self":"https://restapi.e-conomic.com/vat-zones/1"},"nemHandelType":"ean","vat_zone":{"vatZoneNumber":1,"self":"https://restapi.e-conomic.com/vat-zones/1"},"nem_handel_type":"ean"},"layout":{"layoutNumber":16,"self":"https://restapi.e-conomic.com/layouts/16"},"pdf":{"download":"https://restapi.e-conomic.com/orders/sent/15/pdf"},"self":"https://restapi.e-conomic.com/orders/sent/15","attachment":"https://restapi.e-conomic.com/orders/sent/15/attachment","costPriceInBaseCurrency":50.03,"currency":"DKK","date":"2017-01-13","dueDate":"2017-03-02","exchangeRate":100.0,"grossAmount":875.0,"grossAmountInBaseCurrency":875.0,"lines":[{"lineNumber":1,"sortKey":1,"description":"Sidespejl (Sæt) Karma","product":{"productNumber":"100082","self":"https://restapi.e-conomic.com/products/100082"},"quantity":1.0,"unitNetPrice":250.0,"discountPercentage":0.0,"unitCostPrice":50.03,"totalNetAmount":250.0,"marginInBaseCurrency":199.97,"marginPercentage":79.99},{"lineNumber":2,"sortKey":2,"description":"Øvre Stokkeholder Mc","product":{"productNumber":"67","self":"https://restapi.e-conomic.com/products/67"},"quantity":1.0,"unitNetPrice":450.0,"discountPercentage":0.0,"unitCostPrice":0.0,"totalNetAmount":450.0,"marginInBaseCurrency":450.0,"marginPercentage":100.0}],"marginInBaseCurrency":649.97,"marginPercentage":92.85,"netAmount":700.0,"netAmountInBaseCurrency":700.0,"orderNumber":15,"roundingAmount":0.0,"vatAmount":175.0,"customer":{"customerNumber":10001,"self":"https://restapi.e-conomic.com/customers/10001","customer_number":10001},"paymentTerms":{"paymentTermsNumber":2,"daysOfCredit":30,"name":"Løbende måned 30 dage","paymentTermsType":"invoiceMonth","self":"https://restapi.e-conomic.com/payment-terms/2","payment_terms_number":2,"days_of_credit":30,"payment_terms_type":"invoiceMonth"},"pdf":{"download":"https://restapi.e-conomic.com/orders/sent/15/pdf"},"recipient":{"name":"Æblegrød","address":"Bøgevej 32","zip":"5200","city":"Odense V","country":"DK","vatZone":{"vatZoneNumber":1,"self":"https://restapi.e-conomic.com/vat-zones/1"},"nemHandelType":"ean","vat_zone":{"vatZoneNumber":1,"self":"https://restapi.e-conomic.com/vat-zones/1"},"nem_handel_type":"ean"},"templates":{"upgradeInstructions":"https://restapi.e-conomic.com/orders/sent/15/templates/upgrade-instructions/draftInvoice","self":"https://restapi.e-conomic.com/orders/sent/15/templates","upgrade_instructions":"https://restapi.e-conomic.com/orders/sent/15/templates/upgrade-instructions/draftInvoice"}}')
        .to_return(status: 200, body: '{"orderNumber":15,"templates":{"upgradeInstructions":"https://restapi.e-conomic.com/orders/drafts/15/templates/upgrade-instructions/draftInvoice","self":"https://restapi.e-conomic.com/orders/drafts/15/templates"},"soap":{"orderHandle":{"id":45}},"attachment":"https://restapi.e-conomic.com/orders/drafts/15/attachment","lines":[{"lineNumber":1,"sortKey":1,"description":"Sidespejl (Sæt) Karma","product":{"productNumber":"100082","self":"https://restapi.e-conomic.com/products/100082"},"quantity":1.00,"unitNetPrice":250.00,"discountPercentage":0.00,"unitCostPrice":50.03,"totalNetAmount":250.00,"marginInBaseCurrency":199.97,"marginPercentage":79.99},{"lineNumber":2,"sortKey":2,"description":"Øvre Stokkeholder Mc","product":{"productNumber":"67","self":"https://restapi.e-conomic.com/products/67"},"quantity":1.00,"unitNetPrice":450.00,"discountPercentage":0.00,"unitCostPrice":0.00,"totalNetAmount":450.00,"marginInBaseCurrency":450.00,"marginPercentage":100.00}],"date":"2017-01-13","currency":"DKK","exchangeRate":100.000000,"netAmount":700.000000,"netAmountInBaseCurrency":700.00,"grossAmount":875.00,"grossAmountInBaseCurrency":875.00,"marginInBaseCurrency":649.97,"marginPercentage":92.85,"vatAmount":175.000000,"roundingAmount":0.00,"costPriceInBaseCurrency":50.0300,"dueDate":"2017-03-02","paymentTerms":{"paymentTermsNumber":2,"daysOfCredit":30,"name":"Løbende måned 30 dage","paymentTermsType":"invoiceMonth","self":"https://restapi.e-conomic.com/payment-terms/2"},"customer":{"customerNumber":10001,"self":"https://restapi.e-conomic.com/customers/10001"},"recipient":{"name":"Æblegrød","address":"Bøgevej 32","zip":"5200","city":"Odense V","country":"DK","vatZone":{"vatZoneNumber":1,"self":"https://restapi.e-conomic.com/vat-zones/1"},"nemHandelType":"ean"},"layout":{"layoutNumber":16,"self":"https://restapi.e-conomic.com/layouts/16"},"pdf":{"download":"https://restapi.e-conomic.com/orders/drafts/15/pdf"},"self":"https://restapi.e-conomic.com/orders/drafts/15"}', headers: {})
      stub_request(:get, 'https://restapi.e-conomic.com/orders/drafts/15')
        .to_return(status: 200, body: '{"orderNumber":15,"templates":{"upgradeInstructions":"https://restapi.e-conomic.com/orders/drafts/15/templates/upgrade-instructions/draftInvoice","self":"https://restapi.e-conomic.com/orders/drafts/15/templates"},"soap":{"orderHandle":{"id":45}},"attachment":"https://restapi.e-conomic.com/orders/drafts/15/attachment","lines":[{"lineNumber":1,"sortKey":1,"description":"Sidespejl (Sæt) Karma","product":{"productNumber":"100082","self":"https://restapi.e-conomic.com/products/100082"},"quantity":1.00,"unitNetPrice":250.00,"discountPercentage":0.00,"unitCostPrice":50.03,"totalNetAmount":250.00,"marginInBaseCurrency":199.97,"marginPercentage":79.99},{"lineNumber":2,"sortKey":2,"description":"Øvre Stokkeholder Mc","product":{"productNumber":"67","self":"https://restapi.e-conomic.com/products/67"},"quantity":1.00,"unitNetPrice":450.00,"discountPercentage":0.00,"unitCostPrice":0.00,"totalNetAmount":450.00,"marginInBaseCurrency":450.00,"marginPercentage":100.00}],"date":"2017-01-13","currency":"DKK","exchangeRate":100.000000,"netAmount":700.000000,"netAmountInBaseCurrency":700.00,"grossAmount":875.00,"grossAmountInBaseCurrency":875.00,"marginInBaseCurrency":649.97,"marginPercentage":92.85,"vatAmount":175.000000,"roundingAmount":0.00,"costPriceInBaseCurrency":50.0300,"dueDate":"2017-03-02","paymentTerms":{"paymentTermsNumber":2,"daysOfCredit":30,"name":"Løbende måned 30 dage","paymentTermsType":"invoiceMonth","self":"https://restapi.e-conomic.com/payment-terms/2"},"customer":{"customerNumber":10001,"self":"https://restapi.e-conomic.com/customers/10001"},"recipient":{"name":"Æblegrød","address":"Bøgevej 32","zip":"5200","city":"Odense V","country":"DK","vatZone":{"vatZoneNumber":1,"self":"https://restapi.e-conomic.com/vat-zones/1"},"nemHandelType":"ean"},"layout":{"layoutNumber":16,"self":"https://restapi.e-conomic.com/layouts/16"},"pdf":{"download":"https://restapi.e-conomic.com/orders/drafts/15/pdf"},"self":"https://restapi.e-conomic.com/orders/drafts/15"}', headers: {})
      stub_request(:post, 'https://restapi.e-conomic.com//orders/sent')
        .with(body: '{"orderNumber":15,"templates":{"upgradeInstructions":"https://restapi.e-conomic.com/orders/sent/15/templates/upgrade-instructions/draftInvoice","self":"https://restapi.e-conomic.com/orders/sent/15/templates","upgrade_instructions":"https://restapi.e-conomic.com/orders/sent/15/templates/upgrade-instructions/draftInvoice"},"soap":{"orderHandle":{"id":45}},"attachment":"https://restapi.e-conomic.com/orders/sent/15/attachment","lines":[{"lineNumber":1,"sortKey":1,"description":"Sidespejl (Sæt) Karma","product":{"productNumber":"100082","self":"https://restapi.e-conomic.com/products/100082"},"quantity":1.0,"unitNetPrice":250.0,"discountPercentage":0.0,"unitCostPrice":50.03,"totalNetAmount":250.0,"marginInBaseCurrency":199.97,"marginPercentage":79.99},{"lineNumber":2,"sortKey":2,"description":"Øvre Stokkeholder Mc","product":{"productNumber":"67","self":"https://restapi.e-conomic.com/products/67"},"quantity":1.0,"unitNetPrice":450.0,"discountPercentage":0.0,"unitCostPrice":0.0,"totalNetAmount":450.0,"marginInBaseCurrency":450.0,"marginPercentage":100.0}],"date":"2017-01-13","currency":"DKK","exchangeRate":100.0,"netAmount":700.0,"netAmountInBaseCurrency":700.0,"grossAmount":875.0,"grossAmountInBaseCurrency":875.0,"marginInBaseCurrency":649.97,"marginPercentage":92.85,"vatAmount":175.0,"roundingAmount":0.0,"costPriceInBaseCurrency":50.03,"dueDate":"2017-03-02","paymentTerms":{"paymentTermsNumber":2,"daysOfCredit":30,"name":"Løbende måned 30 dage","paymentTermsType":"invoiceMonth","self":"https://restapi.e-conomic.com/payment-terms/2","payment_terms_number":2,"days_of_credit":30,"payment_terms_type":"invoiceMonth"},"customer":{"customerNumber":10001,"self":"https://restapi.e-conomic.com/customers/10001","customer_number":10001},"recipient":{"name":"Æblegrød","address":"Bøgevej 32","zip":"5200","city":"Odense V","country":"DK","vatZone":{"vatZoneNumber":1,"self":"https://restapi.e-conomic.com/vat-zones/1"},"nemHandelType":"ean","vat_zone":{"vatZoneNumber":1,"self":"https://restapi.e-conomic.com/vat-zones/1"},"nem_handel_type":"ean"},"layout":{"layoutNumber":16,"self":"https://restapi.e-conomic.com/layouts/16"},"pdf":{"download":"https://restapi.e-conomic.com/orders/sent/15/pdf"},"self":"https://restapi.e-conomic.com/orders/sent/15","attachment":"https://restapi.e-conomic.com/orders/sent/15/attachment","costPriceInBaseCurrency":50.03,"currency":"DKK","date":"2017-01-13","dueDate":"2017-03-02","exchangeRate":100.0,"grossAmount":875.0,"grossAmountInBaseCurrency":875.0,"lines":[{"lineNumber":1,"sortKey":1,"description":"Sidespejl (Sæt) Karma","product":{"productNumber":"100082","self":"https://restapi.e-conomic.com/products/100082"},"quantity":1.0,"unitNetPrice":250.0,"discountPercentage":0.0,"unitCostPrice":50.03,"totalNetAmount":250.0,"marginInBaseCurrency":199.97,"marginPercentage":79.99},{"lineNumber":2,"sortKey":2,"description":"Øvre Stokkeholder Mc","product":{"productNumber":"67","self":"https://restapi.e-conomic.com/products/67"},"quantity":1.0,"unitNetPrice":450.0,"discountPercentage":0.0,"unitCostPrice":0.0,"totalNetAmount":450.0,"marginInBaseCurrency":450.0,"marginPercentage":100.0}],"marginInBaseCurrency":649.97,"marginPercentage":92.85,"netAmount":700.0,"netAmountInBaseCurrency":700.0,"orderNumber":15,"roundingAmount":0.0,"vatAmount":175.0,"customer":{"customerNumber":10001,"self":"https://restapi.e-conomic.com/customers/10001","customer_number":10001},"paymentTerms":{"paymentTermsNumber":2,"daysOfCredit":30,"name":"Løbende måned 30 dage","paymentTermsType":"invoiceMonth","self":"https://restapi.e-conomic.com/payment-terms/2","payment_terms_number":2,"days_of_credit":30,"payment_terms_type":"invoiceMonth"},"pdf":{"download":"https://restapi.e-conomic.com/orders/sent/15/pdf"},"recipient":{"name":"Æblegrød","address":"Bøgevej 32","zip":"5200","city":"Odense V","country":"DK","vatZone":{"vatZoneNumber":1,"self":"https://restapi.e-conomic.com/vat-zones/1"},"nemHandelType":"ean","vat_zone":{"vatZoneNumber":1,"self":"https://restapi.e-conomic.com/vat-zones/1"},"nem_handel_type":"ean"},"templates":{"upgradeInstructions":"https://restapi.e-conomic.com/orders/sent/15/templates/upgrade-instructions/draftInvoice","self":"https://restapi.e-conomic.com/orders/sent/15/templates","upgrade_instructions":"https://restapi.e-conomic.com/orders/sent/15/templates/upgrade-instructions/draftInvoice"}}').to_return(status: 200, body: '{"orderNumber":15,"templates":{"upgradeInstructions":"https://restapi.e-conomic.com/orders/sent/15/templates/upgrade-instructions/draftInvoice","self":"https://restapi.e-conomic.com/orders/sent/15/templates"},"soap":{"orderHandle":{"id":45}},"attachment":"https://restapi.e-conomic.com/orders/sent/15/attachment","lines":[{"lineNumber":1,"sortKey":1,"description":"Sidespejl (Sæt) Karma","product":{"productNumber":"100082","self":"https://restapi.e-conomic.com/products/100082"},"quantity":1.00,"unitNetPrice":250.00,"discountPercentage":0.00,"unitCostPrice":50.03,"totalNetAmount":250.00,"marginInBaseCurrency":199.97,"marginPercentage":79.99},{"lineNumber":2,"sortKey":2,"description":"Øvre Stokkeholder Mc","product":{"productNumber":"67","self":"https://restapi.e-conomic.com/products/67"},"quantity":1.00,"unitNetPrice":450.00,"discountPercentage":0.00,"unitCostPrice":0.00,"totalNetAmount":450.00,"marginInBaseCurrency":450.00,"marginPercentage":100.00}],"date":"2017-01-13","currency":"DKK","exchangeRate":100.000000,"netAmount":700.000000,"netAmountInBaseCurrency":700.00,"grossAmount":875.00,"grossAmountInBaseCurrency":875.00,"marginInBaseCurrency":649.97,"marginPercentage":92.85,"vatAmount":175.000000,"roundingAmount":0.00,"costPriceInBaseCurrency":50.0300,"dueDate":"2017-03-02","paymentTerms":{"paymentTermsNumber":2,"daysOfCredit":30,"name":"Løbende måned 30 dage","paymentTermsType":"invoiceMonth","self":"https://restapi.e-conomic.com/payment-terms/2"},"customer":{"customerNumber":10001,"self":"https://restapi.e-conomic.com/customers/10001"},"recipient":{"name":"Æblegrød","address":"Bøgevej 32","zip":"5200","city":"Odense V","country":"DK","vatZone":{"vatZoneNumber":1,"self":"https://restapi.e-conomic.com/vat-zones/1"},"nemHandelType":"ean"},"layout":{"layoutNumber":16,"self":"https://restapi.e-conomic.com/layouts/16"},"pdf":{"download":"https://restapi.e-conomic.com/orders/sent/15/pdf"},"self":"https://restapi.e-conomic.com/orders/sent/15"}', headers: {})

      order = Economic::Orders::SentRepo.find(15)
      Economic::Orders::DraftsRepo.send order

      assert Economic::Orders::DraftsRepo.find(15)
      Economic::Orders::SentRepo.send order

      assert Economic::Orders::SentRepo.find(15)
    end
  end
end