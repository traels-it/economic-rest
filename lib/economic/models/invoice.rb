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

      relation :lines, multiple: true
      relation :customer
      relation :payment_terms
      relation :recipient
      relation :notes
      relation :references
      # relation :delivery
      # relation :delivery_location
      # relation :layout
      # relation :pdf
      # relation :project
    end
  end
end
