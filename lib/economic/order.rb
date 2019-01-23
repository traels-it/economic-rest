module Economic
  class Order < Base
    ATTRIBUTES = %w[attachment costPriceInBaseCurrency currency date dueDate exchangeRate grossAmount grossAmountInBaseCurrency lines marginInBaseCurrency marginPercentage netAmount netAmountInBaseCurrency orderNumber roundingAmount vatAmount].freeze
    OBJECTS = %w[customer delivery notes paymentTerms pdf project recipient references templates]
    def id_key
      orderNumber
    end
  end
end
