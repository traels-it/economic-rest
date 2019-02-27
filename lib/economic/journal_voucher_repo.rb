module Economic
  class JournalVoucherRepo < Economic::BaseRepo
    def self.save(voucher)
      response = RestClient.post(
        Economic::JournalRepo.endpoint_url + '/' + voucher.journal.journalNumber.to_s + '/vouchers',
        voucher.to_h.to_json,
        headers
      )

      test_response(response)
    end

    def self.endpoint_name
      raise StandardError, 'only save is available on this repository'
    end
  end
end