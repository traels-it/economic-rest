module Economic
  class PaymentType < Base
    field :name
    field :paymentTypeNumber, id: true
  end
end
