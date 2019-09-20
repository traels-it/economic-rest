require 'test_helper'

class LayoutRepoTest < Minitest::Test
  describe 'For layout' do
    before do
      Economic::Session.authentication('Demo', 'Demo')
    end

    it 'gets all' do
      stub_get_request(endpoint: 'layouts', fixture_name: 'layouts')

      layouts = Economic::LayoutRepo.all

      assert_equal 20, layouts[1].to_h['layoutNumber']
      assert_kind_of Economic::Layout, layouts[0]
    end
  end
end
