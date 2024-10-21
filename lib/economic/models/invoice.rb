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

      relation :customer
      # relation :delivery
      # relation :delivery_location
      # relation :layout
      # relation :notes
      relation :payment_terms
      relation :lines, multiple: true
      # relation :pdf
      # # relation :project
      # relation :recipient
      # relation :references
      # relation :lines, multiple: true
    end
  end
end
