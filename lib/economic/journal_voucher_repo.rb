module Economic
  class JournalVoucherRepo < Economic::BaseRepo
    def self.save(voucher)
      response = send_request(method: :post, url: "#{Economic::JournalRepo.endpoint_url}/#{voucher.journal.journalNumber}/vouchers", payload: voucher.to_h.to_json)

      Voucher.new(JSON.parse(response.body).first)
    end

    def self.endpoint_name
      raise StandardError, "only save is available on this repository"
    end
  end
end
