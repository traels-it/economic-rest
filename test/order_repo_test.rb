require "test_helper"

class OrderRepoTest < Minitest::Test
  describe "For order" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end
    it "gets all" do
      stub_get_request(endpoint: "orders/archived", fixture_name: "orders_archived")
      stub_get_request(endpoint: "orders/drafts", fixture_name: "orders_drafts")
      stub_get_request(endpoint: "orders/sent", fixture_name: "orders_sent")

      orders_archived = Economic::Orders::ArchivedRepo.all
      orders_drafts = Economic::Orders::DraftsRepo.all
      orders_sent = Economic::Orders::SentRepo.all

      assert_equal 35_072, orders_archived[1].to_h["orderNumber"]
      assert_equal 35_070, orders_drafts[0].to_h["orderNumber"]
      assert_equal 35_071, orders_sent[0].to_h["orderNumber"]
      assert_kind_of Economic::Order, orders_archived[0]
      assert_kind_of Economic::Order, orders_drafts[0]
      assert_kind_of Economic::Order, orders_sent[0]
    end

    it "removed field lines from orders gotten by all" do
      stub_get_request(endpoint: "orders/archived", fixture_name: "orders_archived")
      order_archived = Economic::Orders::ArchivedRepo.all.first

      assert_raises(NoMethodError) do
        order_archived.lines
      end
    end

    it "finds based on order number" do
      stub_get_request(endpoint: "orders/archived", page_or_id: "35072", fixture_name: "orders_archived_one")
      stub_get_request(endpoint: "orders/drafts", page_or_id: "35070", fixture_name: "orders_drafts_one")
      stub_get_request(endpoint: "orders/sent", page_or_id: "35071", fixture_name: "orders_sent_one")

      orders_archived_one = Economic::Orders::ArchivedRepo.find(35_072)
      orders_drafts_one = Economic::Orders::DraftsRepo.find(35_070)
      orders_sent_one = Economic::Orders::SentRepo.find(35_071)

      assert_equal 18_187.50, orders_archived_one.to_h["grossAmountInBaseCurrency"]
      assert_equal 1000, orders_drafts_one.to_h["grossAmountInBaseCurrency"]
      assert_equal 1100, orders_sent_one.to_h["grossAmountInBaseCurrency"]
      assert_kind_of Economic::Order, orders_archived_one
      assert_kind_of Economic::Order, orders_drafts_one
      assert_kind_of Economic::Order, orders_sent_one
      assert_kind_of Economic::SalesPerson, orders_drafts_one.references.sales_person
      assert_kind_of Economic::VendorReference, orders_drafts_one.references.vendor_reference
    end

    it "returns json data based on changes to the model" do
      stub_get_request(endpoint: "orders/archived", page_or_id: "35072", fixture_name: "orders_archived_one")
      orders_archived_one = Economic::Orders::ArchivedRepo.find(35_072)

      orders_archived_one.due_date = "2019-12-24"

      assert orders_archived_one.to_h.inspect.include? "2019-12-24"
    end

    it "pulls a sent order back to draft and back to sent" do
      ORDER_NUMBER = 15
      stub_get_request(endpoint: "orders/sent", page_or_id: "15", fixture_name: "orders_sent_one_15")
      stub_get_request(endpoint: "orders/drafts", page_or_id: "15", fixture_name: "orders_drafts_one_15")
      stub_request(:post, "https://restapi.e-conomic.com/orders/drafts").with(body: {"attachment": "https://restapi.e-conomic.com/orders/sent/15/attachment", "costPriceInBaseCurrency": 50.03, "currency": "DKK", "date": "2017-01-13", "dueDate": "2017-03-02", "exchangeRate": 100.0, "grossAmount": 875.0, "grossAmountInBaseCurrency": 875.0, "marginInBaseCurrency": 649.97, "marginPercentage": 92.85, "netAmount": 700.0, "netAmountInBaseCurrency": 700.0, "orderNumber": 15, "roundingAmount": 0.0, "vatAmount": 175.0, "customer": {"customerNumber": 10001}, "lines": [{"lineNumber": 1, "description": "Sidespejl (Sæt) Karma", "sortKey": 1, "quantity": 1.0, "unitNetPrice": 250.0, "discountPercentage": 0.0, "unitCostPrice": 50.03, "marginInBaseCurrency": 199.97, "marginPercentage": 79.99, "totalNetAmount": 250.0, "product": {"productNumber": "100082"}}, {"lineNumber": 2, "description": "Øvre Stokkeholder Mc", "sortKey": 2, "quantity": 1.0, "unitNetPrice": 450.0, "discountPercentage": 0.0, "unitCostPrice": 0.0, "marginInBaseCurrency": 450.0, "marginPercentage": 100.0, "totalNetAmount": 450.0, "product": {"productNumber": "67"}}], "paymentTerms": {"paymentTermsNumber": 2}, "recipient": {"name": "Æblegrød", "vatZone": {"vatZoneNumber": 1}}, "layout": {"layoutNumber": 16}}).to_return(status: 200, body: "", headers: {})
      stub_request(:post, "https://restapi.e-conomic.com/orders/sent").with(body: {"attachment": "https://restapi.e-conomic.com/orders/sent/15/attachment", "costPriceInBaseCurrency": 50.03, "currency": "DKK", "date": "2017-01-13", "dueDate": "2017-03-02", "exchangeRate": 100.0, "grossAmount": 875.0, "grossAmountInBaseCurrency": 875.0, "marginInBaseCurrency": 649.97, "marginPercentage": 92.85, "netAmount": 700.0, "netAmountInBaseCurrency": 700.0, "orderNumber":15,"roundingAmount": 0.0, "vatAmount": 175.0, "customer": {"customerNumber": 10001}, "lines": [{"lineNumber": 1, "description": "Sidespejl (Sæt) Karma", "sortKey": 1, "quantity": 1.0, "unitNetPrice": 250.0, "discountPercentage": 0.0, "unitCostPrice": 50.03, "marginInBaseCurrency": 199.97, "marginPercentage": 79.99, "totalNetAmount": 250.0, "product": {"productNumber": "100082"}}, {"lineNumber": 2, "description": "Øvre Stokkeholder Mc", "sortKey": 2, "quantity": 1.0, "unitNetPrice": 450.0, "discountPercentage": 0.0, "unitCostPrice": 0.0, "marginInBaseCurrency": 450.0, "marginPercentage": 100.0, "totalNetAmount": 450.0, "product": {"productNumber": "67"}}], "paymentTerms": {"paymentTermsNumber": 2}, "recipient": {"name": "Æblegrød", "vatZone": {"vatZoneNumber": 1}}, "layout": {"layoutNumber": 16}}).to_return(status: 200, body: "", headers: {})
      order = Economic::Orders::SentRepo.find(ORDER_NUMBER)

      Economic::Orders::DraftsRepo.send order
      assert Economic::Orders::DraftsRepo.find(ORDER_NUMBER)
      Economic::Orders::SentRepo.send order

      assert Economic::Orders::SentRepo.find(ORDER_NUMBER)
    end

    it "contains delivery date" do
      stub_get_request(endpoint: "orders/drafts", page_or_id: "97", fixture_name: "orders_drafts_one_97")
      delivery = Economic::Orders::DraftsRepo.find(97).delivery
      assert_equal "Peter\nCookievej 7", delivery.address
      assert_equal "Aarhus C", delivery.city
      assert_equal "Danmark", delivery.country
      assert_equal "8000", delivery.zip
    end

    it "filters" do
      stub_get_request(endpoint: "orders/archived", fixture_name: "orders_archived")
      stub_request(:get, "https://restapi.e-conomic.com/orders/archived?filter=orderNumber$eq:35071&pagesize=1000&skippages=0").to_return(status: 200, body: File.read(json_fixture("orders_drafts")), headers: {})

      assert_equal 2, Economic::Orders::ArchivedRepo.all.count
      assert_equal 1, Economic::Orders::ArchivedRepo.all(filter_text: "orderNumber$eq:35071").count
      assert_equal 1, Economic::Orders::ArchivedRepo.filter("orderNumber$eq:35071").count
    end
  end
end
