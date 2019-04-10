module Economic
  class Pricing < Base
    field :price
    relation :currency, fields: [:code]
    relation :product, fields: [:productNumber]
  end
end
