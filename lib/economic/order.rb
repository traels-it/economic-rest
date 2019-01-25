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

    field :customer
    field :delivery
    field :notes
    field :paymentTerms
    field :pdf
    field :project
    field :recipient
    field :references
    field :templates
  end
end
