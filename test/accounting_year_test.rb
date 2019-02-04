require 'test_helper'

class AccountingYearTest < Minitest::Test
  describe 'For Journal' do
    it 'makes' do
      assert Economic::AccountingYear.new({})
    end
  end
end
