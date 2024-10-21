module Economic
  class Invoice < Base
    # currency, customer, date, layout, paymentTerms, recipient, recipient.name, recipient.vatZone
    field :currency
    field :date
    field :dueDate
    field :exchangeRate
    field :grossAmount
    field :grossAmountInBaseCurrency
    field :marginInBaseCurrency
    field :marginPercentage
    field :netAmount
    field :roundingAmount
    field :vatAmount
    field :draftInvoiceNumber, id: true # This changes name depending on its type (draft, unpaid etc)
    field :bookedInvoiceNumber
    field :remainder

    relation :customer, fields: [:customerNumber]
    relation :delivery, fields: []
    # relation :deliveryLocation, fields: []
    relation :layout, fields: [:layoutNumber]
    relation :notes, fields: []
    relation :paymentTerms, fields: [:paymentTermsNumber]
    relation :pdf, fields: [:download]
    # relation :project, fields: []
    relation :recipient, fields: []
    relation :references, fields: [:other]
    relation :lines, fields: [:lineNumber, :description, :sortKey, :quantity, :unitNetPrice, :discountPercentage, :unitCostPrice, :marginInBaseCurrency, :marginPercentage, :totalNetAmount], multiple: true

    def self.repo
      Economic::Invoices::DraftsRepo
    end
  end
end
