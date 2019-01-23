module Economic
  class Product < Base
    ATTRIBUTES = %w[barCode barred costPrice description lastUpdated name productNumber recommendedPrice salesPrice].freeze
    OBJECTS = %w[departmentalDistribution inventory invoices pricing productGroup unit]
    def id_key
      productNumber
    end
  end
end
