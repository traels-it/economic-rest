module Economic
  class Line < Base
    field :lineNumber
    field :description
    field :sortKey
    field :quantity
    field :unitNetPrice
    field :discountPercentage
    field :unitCostPrice
    field :marginInBaseCurrency
    field :marginPercentage
    field :totalNetAmount

    relation :product, fields: []
    relation :unit, fields: []
    relation :delivery, fields: []
    relation :departmentalDistribution, fields: []
  end
end
