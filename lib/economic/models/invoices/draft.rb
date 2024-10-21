module Economic
  module Models
    module Invoices
      class Draft < Economic::Models::Invoice
        field :id, as: :draftInvoiceNumber

        # This could be cool to move to Economic::Model
        Economic::Models::Invoice.attributes.each do |attribute|
          attributes << attribute
        end
      end
    end
  end
end
