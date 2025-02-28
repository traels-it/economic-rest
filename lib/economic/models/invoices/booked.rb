module Economic
  module Models
    module Invoices
      class Booked < Economic::Models::Invoice
        field :id, as: :bookedInvoiceNumber

        relation :draft_invoice, klass: "Economic::Models::Invoices::Draft"
        relation :pdf
      end
    end
  end
end
