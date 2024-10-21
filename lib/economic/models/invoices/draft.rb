module Economic
  module Models
    module Invoices
      class Draft < Economic::Models::Invoice
        field :id, as: :draftInvoiceNumber
      end
    end
  end
end
