module Economic
  module Resources
    module Invoices
      module Drafts
        class LineResource < Economic::Resource
          def create(*models)
            draft_invoice_model_or_id = models[0]
            draft_invoice_id = draft_invoice_model_or_id.try(:id) || draft_invoice_model_or_id
            lines = models[1]
            draft_invoice = Economic::Models::Invoices::Draft.new(lines: lines)

            uri = URI("#{Resource::ROOT}/invoices/drafts/#{draft_invoice_id}/lines")

            make_request(uri: uri, method: :post, data: draft_invoice)
          end

          private

          def parse_response(response)
            JSON.parse(response.body)["lines"].map do |line_data|
              Economic::Models::Line.from_hash(**line_data)
            end
          end
        end
      end
    end
  end
end
