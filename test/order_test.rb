require 'test_helper'

class OrderTest < Minitest::Test
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

      orders_archived_one = Economic::Orders::ArchivedRepo.find(35072)
      orders_drafts_one = Economic::Orders::DraftsRepo.find(35070)
      orders_sent_one = Economic::Orders::SentRepo.find(35071)

      assert_equal 18187.50, orders_archived_one.to_h['grossAmountInBaseCurrency']
      assert_equal 1000, orders_drafts_one.to_h['grossAmountInBaseCurrency']
      assert_equal 1100, orders_sent_one.to_h['grossAmountInBaseCurrency']
      assert_kind_of Economic::Order, orders_archived_one
      assert_kind_of Economic::Order, orders_drafts_one
      assert_kind_of Economic::Order, orders_sent_one
    end

    it 'returns json data based on changes to the model' do
      stub_get_request(endpoint: 'orders/archived', page_or_id: '35072', fixture_name: 'orders_archived_one')
      orders_archived_one = Economic::Orders::ArchivedRepo.find(35072)

      orders_archived_one.due_date = '2019-12-24'

      assert orders_archived_one.to_h.inspect.include? '2019-12-24'
    end
  end
end
