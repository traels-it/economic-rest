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
    relation :recipient, fields: [:name, :ean]
    relation :references, fields: [:other]
    relation :lines, fields: [:lineNumber, :description, :sortKey, :quantity, :unitNetPrice, :discountPercentage, :unitCostPrice, :marginInBaseCurrency, :marginPercentage, :totalNetAmount], multiple: true

    def self.build_from_soap_api(data)
      # TODO: Add all the options
      hash = {
        "currency" => data[:currency_handle][:code],
        "date" => data[:date].to_date,
        "dueDate" => data[:due_date].to_date,
        "exchangeRate" => data[:exchange_rate],
        "grossAmount" => data[:gross_amount],
        # where is grossAmountInBaseCurrency?
        "lines" => repo.find_lines(data[:handle][:id]),
        "marginInBaseCurrency" => data[:margin],
        "marginPercentage" => data[:margin_as_percent],
        "netAmount" => data[:net_amount],
        "roundingAmount" => data[:rounding_amount],
        "vatAmount" => data[:vat_amount],
        "draftInvoiceNumber" => data[:handle][:id], # TODO: What about id?
        "customer" => {"customerNumber" => data[:debtor_handle][:id].to_i},
        "layout" => {"layoutNumber" => data[:layout_handle][:id].to_i},
        "paymentTerms" => {"paymentTermsNumber" => data[:term_of_payment_handle][:id].to_i},
        "references" => {"other" => data[:other_reference]},
      }

      new(hash)
    end

    def self.repo
      Economic::Invoices::DraftsRepo
    end
  end
end
