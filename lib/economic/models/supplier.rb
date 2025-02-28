module Economic
  module Models
    class Supplier < Economic::Model
      field :id, as: :supplierNumber
      field :address
      field :bank_account
      field :barred
      field :city
      field :contacts
      field :corporate_identification_number
      field :country
      field :currency
      field :default_invoice_text
      field :email
      field :name
      field :phone
      field :zip

      relation :attention
      relation :cost_account
      relation :layout
      relation :payment_terms
      relation :remittance_advice
      relation :sales_person
      relation :supplier_contact
      relation :supplier_group
      relation :vat_zone
    end
  end
end
