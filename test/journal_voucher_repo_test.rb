require 'test_helper'

class JournalVoucherRepoTest < Minitest::Test
  describe 'repository for vouchers on a journal' do
    before do
      Economic::Session.authentication('Demo', 'Demo')
      stub_get_request(endpoint: 'journals-experimental', page_or_id: 2, fixture_name: 'journal')
    end

    it 'only implements save' do
      assert_raises StandardError do
        Economic::JournalVoucherRepo.all
      end
    end

    it 'creates finance vouchers' do
      stub_request(:post, 'https://restapi.e-conomic.com/journals-experimental/5/vouchers')
        .with(
          body: { "accountingYear": { "year": '2017' }, "journal": { "journalNumber": 5 }, "entries": { "financeVouchers": [{ "contraAccount": { "accountNumber": 1010 }, "amount": 100, "date": '2017-02-01' }] } }
        ).to_return(status: 201, body: '', headers: {})

      v = Economic::Voucher.new({})
      v.entries = { 'financeVouchers':
          [{
            'contraAccount': {
              'accountNumber': 1010
            },
            'amount': 100,
            'date': '2017-02-01'
          }] }
      v.journal.journalNumber = 5
      v.accountingYear.year = '2017'

      assert Economic::JournalVoucherRepo.save(v)
    end

    it 'can create customer payment vouchers' do
      stub_request(:post, 'https://restapi.e-conomic.com/journals-experimental/2/vouchers')
        .with(
          body: { "journal": { "journalNumber": 2 }, "entries": { "customerPayments": [{ "customer": { "customerNumber": 1 }, "amount": 100, "date": '2017-05-03' }] }, "accountingYear": { "year": '2017' } }
        )
        .to_return(status: 201, body: '[{"accountingYear":{"year":"2017","self":"https://restapi.e-conomic.com/accounting-years/2017"},"journal":{"journalNumber":2,"self":"https://restapi.e-conomic.com/journals-experimental/2"},"entries":{"customerPayments":[{"customer":{"customerNumber":1,"self":"https://restapi.e-conomic.com/customers/1"},"journal":{"journalNumber":2,"self":"https://restapi.e-conomic.com/journals-experimental/2"},"amount":100.00,"currency":{"code":"DKK","self":"https://restapi.e-conomic.com/currencies/DKK"},"date":"2017-05-03","exchangeRate":100.000000,"entryType":"customerPayment","voucher":{"accountingYear":{"year":"2017","self":"https://restapi.e-conomic.com/accounting-years/2017"},"voucherNumber":50026,"attachment":"https://restapi.e-conomic.com/journals-experimental/2/vouchers/2017-50026/attachment","self":"https://restapi.e-conomic.com/journals-experimental/2/vouchers/2017-50026"},"amountDefaultCurrency":100.00,"remainder":100.00,"remainderDefaultCurrency":100.00,"journalEntryNumber":27,"metaData":{"delete":{"description":"Delete this entry.","href":"https://restapi.e-conomic.com/journals-experimental/2/entries/27","httpMethod":"delete"}},"self":"https://restapi.e-conomic.com/journals-experimental/2/entries/27"}]},"voucherNumber":50026,"attachment":"https://restapi.e-conomic.com/journals-experimental/2/vouchers/2017-50026/attachment","self":"https://restapi.e-conomic.com/journals-experimental/2/vouchers/2017-50026"}]', headers: {})

      v = Economic::Voucher.new({})
      v.entries = { 'customerPayments':
          [{
            'customer': {
              'customerNumber': 1
            },
            'amount': 100,
            'date': '2017-05-03'
          }] }
      v.journal.journalNumber = 2
      v.accountingYear.year = '2017'

      assert Economic::JournalVoucherRepo.save(v)
    end
  end
end
