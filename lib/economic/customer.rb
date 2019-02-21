module Economic
  class Customer < Base
    field :address
    field :balance
    field :barred
    field :city
    field :contacts
    field :corporateIdentificationNumber
    field :country
    field :creditLimit
    field :currency
    field :customerNumber, id: true
    field :deliveryLocations
    field :dueAmount
    field :ean
    field :email
    field :lastUpdated
    field :name
    field :mobilePhone
    field :pNumber
    field :publicEntryNumber
    field :telephoneAndFaxNumber
    field :vatNumber
    field :website
    field :zip

    #field :attention
    #field :customerContact
    relation :customerGroup, fields: [:customerGroupNumber]
    #field :defaultDeliveryLocation
    #field :invoices
    #field :layout
    relation :paymentTerms, fields: [:paymentTermsNumber]
    #field :salesPerson
    #field :templates
    #field :totals
    relation :vatZone, fields: [:vatZoneNumber]
  end
end
