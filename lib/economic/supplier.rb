module Economic
  class Supplier < Base
    field :address
    field :bankAccount
    field :barred
    field :city
    field :contacts
    field :corporateIndentificationNumber
    field :country
    field :currency
    field :defaultInvoiceText
    field :email
    field :name
    field :phone
    field :supplierNumber, id: true
    field :zip

    relation :attention, fields: [:supplierContactNumber]
    # relation :costAccount, fields: [:accountNumber]
    relation :layout, fields: [:layoutNumber]
    relation :paymentTerms, fields: [:paymentTermsNumber]
    # relation :remittanceAdvice
    # relation :salesPerson
    # relation :supplierContact
    relation :supplierGroup, fields: [:supplierGroupNumber]
    relation :vatZone, fields: [:vatZoneNumber]
  end
end
