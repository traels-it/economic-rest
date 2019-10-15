module Economic
  class CustomerContactRepo < Economic::NestedBaseRepo
    class << self
      def endpoint
        "contacts"
      end
    end
  end
end
