module Economic
  class Order < Base
    field :attachment
    field :costPriceInBaseCurrency
    field :currency
    field :date
    field :dueDate
    field :exchangeRate
    field :grossAmount
    field :grossAmountInBaseCurrency
    field :lines
    field :marginInBaseCurrency
    field :marginPercentage
    field :netAmount
    field :netAmountInBaseCurrency
    field :orderNumber, id: true
    field :roundingAmount
    field :vatAmount

    relation :customer, fields: [:customerNumber]
    #   relation :delivery, fields: []
    #    relation :notes, fields: []
    relation :paymentTerms, fields: [:paymentTermsNumber]
    #   relation :pdf, fields: []
    #    relation :project, fields: []
    relation :recipient, fields: [:name]
    relation :references, fields: [:other]
    relation :layout, fields: [:layoutNumber]
  end
end
