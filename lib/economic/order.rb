module Economic
  class Order < Base
    ATTRIBUTES = %w[attachment costPriceInBaseCurrency currency date dueDate exchangeRate grossAmount grossAmountInBaseCurrency lines marginInBaseCurrency marginPercentage netAmount netAmountInBaseCurrency orderNumber roundingAmount vatAmount].freeze
    OBJECTS = %w[customer delivery notes paymentTerms pdf project recipient references templates]
    def id_key
      orderNumber
    end

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
    field name: 'orderNumber'
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
