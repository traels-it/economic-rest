module Economic
  class DepartmentalDistributionRepo < Economic::BaseRepo
    class << self
      def all(distribution: nil)
        return super(url: endpoint_url(distribution)) unless distribution.nil?

        super(url: endpoint_url(distribution))
      end

      def find(id, distribution:)
        super(id, url: endpoint_url(distribution))
      end

      private

      def endpoint_url(distribution)
        return super() if distribution.nil?
        return super() + "/departments" if distribution == :single_department

        super() + "/distributions"
      end
    end
  end
end
