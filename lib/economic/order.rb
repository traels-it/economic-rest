module Economic
  class Order < Base
    field name: 'attachment'
    field name: 'costPriceInBaseCurrency'
    field name: 'currency'
    field name: 'date'
    field name: 'dueDate'
    field name: 'exchangeRate'
    field name: 'grossAmount'
    field name: 'grossAmountInBaseCurrency'
    field name: 'lines'
    field name: 'marginInBaseCurrency'
    field name: 'marginPercentage'
    field name: 'netAmount'
    field name: 'netAmountInBaseCurrency'
    field name: 'orderNumber', id: true
    field name: 'roundingAmount'
    field name: 'vatAmount'

    field name: 'customer'
    field name: 'delivery'
    field name: 'notes'
    field name: 'paymentTerms'
    field name: 'pdf'
    field name: 'project'
    field name: 'recipient'
    field name: 'references'
    field name: 'templates'
  end
end
