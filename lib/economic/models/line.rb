module Economic
  module Models
    class Line < Economic::Model
      field :id, as: :lineNumber
      field :description
      field :sort_key
      field :quantity
      field :unit_net_price
      field :discount_percentage
      field :unit_cost_price
      field :margin_in_base_currency
      field :margin_percentage
      field :total_net_amount

      relation :product
      relation :unit
      # relation :delivery
      # relation :departmental_distribution
    end
  end
end
