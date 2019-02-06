require 'test_helper'

class JournalRepoTest < Minitest::Test
  describe 'For Journal' do
    before do
      Economic::Session.authentication('Demo', 'Demo')
    end

    it 'gets all' do
      stub_get_request(endpoint: 'journals-experimental', fixture_name: 'journals_0')

      journals = Economic::JournalRepo.all

      assert_equal 3, journals[2].to_h['journalNumber']
      assert_kind_of Economic::Journal, journals[0]
    end

    it 'finds based on customer number' do
      stub_get_request(endpoint: 'journals-experimental', page_or_id: 2, fixture_name: 'journal')

      journal = Economic::JournalRepo.find(2)

      assert_equal 'Lønninger', journal.to_h['name']
      assert_kind_of Economic::Journal, journal
    end

    it 'returns json data based on changes to the model' do
      stub_get_request(endpoint: 'journals-experimental', page_or_id: 2, fixture_name: 'journal')

      journal = Economic::JournalRepo.find(2)

      assert journal.to_h.inspect.include? 'Lønninger'
    end

    it 'gets vouchers on a journal' do
      stub_get_request(endpoint: 'journals-experimental', page_or_id: 2, fixture_name: 'journal')

      stub_request(:post, 'https://restapi.e-conomic.com/journals-experimental/2/vouchers')
        .with(
          body: { "journal": { "journalNumber": 2 }, "entries": { "customerPayments": [{ "customer": { "customerNumber": 1 }, "amount": 100, "date": '2017-05-03' }] }, "accountingYear": { "year": '2017' } }
        )
        .to_return(status: 201, body: '[{"accountingYear":{"year":"2017","self":"https://restapi.e-conomic.com/accounting-years/2017"},"journal":{"journalNumber":2,"self":"https://restapi.e-conomic.com/journals-experimental/2"},"entries":{"customerPayments":[{"customer":{"customerNumber":1,"self":"https://restapi.e-conomic.com/customers/1"},"journal":{"journalNumber":2,"self":"https://restapi.e-conomic.com/journals-experimental/2"},"amount":100.00,"currency":{"code":"DKK","self":"https://restapi.e-conomic.com/currencies/DKK"},"date":"2017-05-03","exchangeRate":100.000000,"entryType":"customerPayment","voucher":{"accountingYear":{"year":"2017","self":"https://restapi.e-conomic.com/accounting-years/2017"},"voucherNumber":50026,"attachment":"https://restapi.e-conomic.com/journals-experimental/2/vouchers/2017-50026/attachment","self":"https://restapi.e-conomic.com/journals-experimental/2/vouchers/2017-50026"},"amountDefaultCurrency":100.00,"remainder":100.00,"remainderDefaultCurrency":100.00,"journalEntryNumber":27,"metaData":{"delete":{"description":"Delete this entry.","href":"https://restapi.e-conomic.com/journals-experimental/2/entries/27","httpMethod":"delete"}},"self":"https://restapi.e-conomic.com/journals-experimental/2/entries/27"}]},"voucherNumber":50026,"attachment":"https://restapi.e-conomic.com/journals-experimental/2/vouchers/2017-50026/attachment","self":"https://restapi.e-conomic.com/journals-experimental/2/vouchers/2017-50026"}]', headers: {})

      journal = Economic::JournalRepo.find(2)
      v = Economic::Voucher.new({})
      v.entries = { 'customerPayments':
          [{
            'customer': {
              'customerNumber': 1
            },
            'amount': 100,
            'date': '2017-05-03'
          }] }
      v.journal = { "journalNumber": 2 }
      v.accountingYear.year = '2017'
      assert journal.create_voucher(v)
    end

    it 'post financeVouchers' do
      stub_get_request(endpoint: 'journals-experimental', page_or_id: 5, fixture_name: 'journal_5')

      stub_request(:post, 'https://restapi.e-conomic.com/journals-experimental/5/vouchers')
        .with(
          body: { "accountingYear": { "year": '2017', "year": '2017' }, "journal": { "journalNumber": 5 }, "entries": { "financeVouchers": [{ "contraAccount": { "accountNumber": 1010 }, "amount": 100, "date": '2017-02-01' }] } }
        ).to_return(status: 201, body: '', headers: {})

      journal = Economic::JournalRepo.find(5)
      v = Economic::Voucher.new({})
      v.entries = { 'financeVouchers':
          [{
            'contraAccount': {
              'accountNumber': 1010
            },
            'amount': 100,
            'date': '2017-02-01'
          }] }
      v.journal = { "journalNumber": 5 }
      v.accountingYear.year = '2017'
      journal.create_voucher(v)
    end
  end
end
