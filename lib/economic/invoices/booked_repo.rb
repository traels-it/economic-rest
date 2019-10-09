module Economic
  module Invoices
    class BookedRepo < Economic::Invoices::Repo
      class << self
        def send(invoice)
          response = send_request(method: :post, url: URI.escape(endpoint_url), payload: payload(invoice))

          entry_hash = JSON.parse(response.body)

          invoice.class.new(entry_hash)
        end

        private

        def payload(invoice)
          {
            draftInvoice: invoice.to_h,
          }.to_json
        end
      end
    end
  end
end
