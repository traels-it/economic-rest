module Economic
  class Order < Base
    ATTRIBUTES = %w[costPriceInBaseCurrency currency date dueDate exchangeRate grossAmount grossAmountInBaseCurrency marginInBaseCurrency marginPercentage netAmount netAmountInBaseCurrency orderNumber roundingAmount vatAmount].freeze
    OBJECTS = %w[customer delivery notes paymentTerms pdf project recipient references templates]
    def id_key
      orderNumber
    end
  end
end
