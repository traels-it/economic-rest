module Economic
  class PaymentTermsRepo < Economic::BaseRepo
    class << self
      def endpoint
        "payment-terms"
      end
    end
  end
end
