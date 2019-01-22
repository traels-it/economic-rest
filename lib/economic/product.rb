module Economic
  class Product < Base
    ATTRIBUTES = %w[barCode barred costPrice description name productNumber recommendedPrice salesPrice].freeze
    OBJECTS = %w[departmentalDistribution inventory invoices productGroup unit]
    def id_key
      productNumber
    end
  end
end
