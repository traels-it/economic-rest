module Economic
  class RemittanceAdvice < Base
    field :creditorId

    relation :paymentType, fields: [:paymentTypeNumber]
  end
end
