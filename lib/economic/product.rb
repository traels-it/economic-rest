module Economic
  class Product < Base
    ATTRIBUTES = %w[barred costPrice description name productNumber recommendedPrice salesPrice].freeze
    OBJECTS = %w[departmentalDistribution inventory invoices productGroup unit]
  end
end
