module Economic
  class Product < Base
    field :barCode
    field :barred
    field :costPrice
    field :description
    field :lastUpdated
    field :name
    field :productNumber, id: true
    field :recommendedPrice
    field :salesPrice

    # field :departmentalDistribution
    relation :inventory, fields: []
    # field :invoices
    # field :pricing
    relation :productGroup, fields: [:productGroupNumber]
    relation :unit, fields: [:unitNumber]
  end
end
