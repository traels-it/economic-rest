require "test_helper"

module Repos
  class AccountingYearTest < Minitest::Test
    describe Economic::Repos::AccountingYear do
      before { set_credentials }

      describe "#all" do
        it "fetches all accounting years" do
          stub_get_request(endpoint: "accounting-years", fixture_name: "accounting_years")

          accounting_years = Economic::Repos::AccountingYear.new.all

          assert_equal 5, accounting_years.size
          assert_equal "2015-01-01", accounting_years.first.from_date
          assert_equal "2019-12-31", accounting_years.last.to_date
        end

        it "can filter records" do
          stub_get_request(endpoint: "accounting-years", filter: "fromDate$gte:2022-01-01$and:toDate$lte:2023-12-31", fixture_name: "filtered_accounting_years")
          from_date = Date.new(2022, 1, 1)
          to_date = Date.new(2023, 12, 31)

          accounting_years = Economic::Repos::AccountingYear.new.all(filter: "fromDate$gte:#{from_date}$and:toDate$lte:#{to_date}")

          assert_equal 2, accounting_years.size
          assert_equal "2022-01-01", accounting_years.first.from_date
          assert_equal "2023-12-31", accounting_years.last.to_date
        end
      end
    end
  end
end
