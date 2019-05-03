require 'test_helper'

class AccountingYearRepoTest < Minitest::Test
  describe 'For Accounting Year' do
    before do
      Economic::Session.authentication('Demo', 'Demo')
    end

    it 'get account years from from from and to dates' do
      stub_get_request(endpoint: 'accounting-years', fixture_name: 'accounting_years')

      accounting_years = Economic::AccountingYearRepo.all

      assert_equal '2015-01-01', accounting_years.first.from_date
      assert_equal '2019-12-31', accounting_years.last.to_date
    end
  end
end
