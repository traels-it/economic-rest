require 'test_helper'

class UnitRepoTest < Minitest::Test
  describe 'For unit' do
    before do
      Economic::Session.authentication('Demo', 'Demo')
    end

    it 'gets all' do
      stub_get_request(endpoint: 'units', fixture_name: 'units')

      units = Economic::UnitRepo.all

      assert_equal 'stk.', units[0].to_h['name']
      assert_kind_of Economic::Unit, units[0]
    end
  end
end
