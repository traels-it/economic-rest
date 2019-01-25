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

    field :attention
    field :customerContact
    field :customerGroup
    field :defaultDeliveryLocation
    field :invoices
    field :layout
    field :paymentTerms
    field :salesPerson
    field :templates
    field :totals
    field :vatZone
  end
end
