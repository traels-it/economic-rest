module Economic
  module Invoices
    class BookedRepo < Economic::Invoices::Repo
      class << self
        def save(invoice, book_with_number: nil, send_by: nil)
          response = send_request(method: :post, url: endpoint_url, payload: payload(invoice, book_with_number: book_with_number, send_by: send_by))

          entry_hash = JSON.parse(response.body)

          invoice.class.new(entry_hash)
        end

        private

        def payload(invoice, book_with_number: nil, send_by: nil)
          payload = {draftInvoice: invoice.to_h}
          payload = payload.merge({bookWithNumber: book_with_number}) unless book_with_number.nil?
          payload = payload.merge({sendBy: "ean"}) if send_by.to_s == "ean"

          payload.to_json
        end
      end
    end
  end
end
