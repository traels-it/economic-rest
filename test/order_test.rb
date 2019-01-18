require 'test_helper'

class OrderTest < Minitest::Test
  describe 'order object' do
    before do
      Economic::Session.authentication('Demo', 'Demo')
    end
    it 'gets all' do
      #stub_get_request(endpoint: 'orders', fixture_name: 'products_0')
      WebMock.allow_net_connect!

      orders = Economic::Orders::ArchivedRepo.all
      puts "ArchivedRepo orders.count #{orders.count}"
      orders = Economic::Orders::DraftsRepo.all
      puts "DraftsRepo orders.count #{orders.count}"
      orders = Economic::Orders::SentRepo.all
      puts "SentRepo orders.count #{orders.count}"
    end
  end
end
