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

    field :departmentalDistribution
    field :inventory
    field :invoices
    field :pricing
    field :productGroup
    field :unit
  end
end
