module Economic
  class JournalRepo < Economic::BaseRepo
    class << self
      def endpoint
        "journals-experimental"
      end
    end
  end
end
