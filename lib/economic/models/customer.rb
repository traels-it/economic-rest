module Economic
  module Models
    class Customer < Economic::Model
      field :id, as: :customerNumber
      field :address
      field :balance
      field :barred
      field :city
      field :contacts
      field :corporate_identification_number
      field :country
      field :credit_limit
      field :currency
      field :delivery_locations
      field :due_amount
      field :ean
      field :email
      field :last_updated
      field :name
      field :mobile_phone
      field :p_number
      field :public_entry_number
      field :telephone_and_fax_number
      field :vat_number
      field :website
      field :zip

      # # field :attention
      # # field :customerContact
      relation :customer_group
      # # field :defaultDeliveryLocation
      # # field :invoices
      # relation :layout, fields: [:layoutNumber]
      relation :payment_terms
      # # field :salesPerson
      # field :templates
      # # field :totals
      relation :vat_zone
    end
  end
end