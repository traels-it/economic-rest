module Economic
  module Invoices
    class BookedRepo < Economic::Invoices::Repo
      class << self
        def send(invoice, book_with_number: nil)
          response = send_request(method: :post, url: URI.escape(endpoint_url), payload: payload(invoice, book_with_number: book_with_number))

          entry_hash = JSON.parse(response.body)

          invoice.class.new(entry_hash)
        end

        private

        def payload(invoice, book_with_number: nil)
          payload = {draftInvoice: invoice.to_h}
          payload = payload.merge({bookWithNumber: book_with_number}) unless book_with_number.nil?

          payload.to_json
        end
      end
    end
  end
end
