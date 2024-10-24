module Economic
  module Models
    class Product < Economic::Model
      field :id, as: :productNumber
      field :bar_code
      field :barred
      field :cost_price
      field :description
      field :last_updated
      field :name
      field :recommended_price
      field :sales_price

      # field :departmental_distribution
      # relation :inventory
      # field :invoices
      # field :pricing
      # relation :product_group
      # relation :unit
    end
  end
end
