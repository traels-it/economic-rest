require "test_helper"

class VoucherTest < Minitest::Test
  describe "For Vouchers" do
    it "tests field hash" do
      voucher = Economic::Voucher.new({})
      voucher.voucher_number = 22

      assert_equal '{"voucherNumber":22}', voucher.to_h.to_json
    end

    it "tests relations hash low_camel_case" do
      voucher = Economic::Voucher.new({})

      voucher.accountingYear.year = "2019"

      assert_equal '{"accountingYear":{"year":"2019"}}', voucher.to_h.to_json
    end

    it "tests relations hash snake_cased" do
      voucher = Economic::Voucher.new({})

      voucher.accounting_year.year = "2019"

      assert_equal '{"accountingYear":{"year":"2019"}}', voucher.to_h.to_json
    end
  end
end
