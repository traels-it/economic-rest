module Economic
  module Models
    class Invoice < Economic::Model
      field :currency
      field :date
      field :due_date
      field :exchange_rate
      field :gross_amount
      field :gross_amount_in_base_currency
      field :margin_in_base_currency
      field :margin_percentage
      field :net_amount
      field :rounding_amount
      field :vat_amount
      field :remainder
      field :cost_price_in_base_currency
      field :net_amount_in_base_currency

      relation :lines, multiple: true
      relation :customer
      relation :payment_terms
      relation :recipient
      relation :notes
      relation :references
      relation :layout
      relation :delivery
      # relation :delivery_location
      relation :pdf
      # relation :project
    end
  end
end
