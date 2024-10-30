module Economic
  module Repos
    module Invoices
      module Drafts
        class Line < Economic::Repo
          def create(draft_invoice_model_or_id, lines)
            draft_invoice_id = draft_invoice_model_or_id.try(:id) || draft_invoice_model_or_id
            draft_invoice = Economic::Models::Invoices::Draft.new(lines: lines)

            uri = URI("#{Economic::Repo::ROOT}/invoices/drafts/#{draft_invoice_id}/lines")

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
