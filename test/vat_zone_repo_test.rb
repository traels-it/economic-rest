require 'test_helper'

class VatZoneRepoTest < Minitest::Test
  describe 'For vat zone' do
    before do
      Economic::Session.authentication('Demo', 'Demo')
    end

    it 'gets all' do
      stub_get_request(endpoint: 'vat-zones', fixture_name: 'vat_zones')

      vat_zones = Economic::VatZoneRepo.all

      assert_equal 'Abroad', vat_zones[2].to_h['name']
      assert_kind_of Economic::VatZone, vat_zones[0]
    end
  end
end
