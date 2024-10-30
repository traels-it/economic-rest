module Economic
  module Models
    class PaymentTerm < Economic::Model
      field :days_of_credit
      field :name
      field :payment_terms_number
      field :payment_terms_type
    end
  end
end
