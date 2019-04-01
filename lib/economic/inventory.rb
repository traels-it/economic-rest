module Economic
  class Inventory < Base
    field :inventory
    field :available
    field :inStock
    field :orderedFromSuppliers
    field :orderedByCustomers
    field :netWeight
    field :grossWeight
    field :packageVolume
    field :recommendedCostPrice
  end
end
