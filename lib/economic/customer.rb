module Economic
  class Customer < Base
    ATTRIBUTES = %w[address balance barred city contacts corporateIdentificationNumber country creditLimit currency customerNumber deliveryLocations dueAmount ean email lastUpdated name mobilePhone pNumber publicEntryNumber telephoneAndFaxNumber vatNumber website zip].freeze
    OBJECTS = %w[attention customerContact customerGroup defaultDeliveryLocation invoices layout paymentTerms salesPerson templates totals vatZone]
    def id_key
      customerNumber
    end

    field name: 'address'
    field name: 'balance'
    field name: 'barred'
    field name: 'city'
    field name: 'contacts'
    field name: 'corporateIdentificationNumber'
    field name: 'country'
    field name: 'creditLimit'
    field name: 'currency'
    field name: 'customerNumber'
    field name: 'deliveryLocations'
    field name: 'dueAmount'
    field name: 'ean'
    field name: 'email'
    field name: 'lastUpdated'
    field name: 'name'
    field name: 'mobilePhone'
    field name: 'pNumber'
    field name: 'publicEntryNumber'
    field name: 'telephoneAndFaxNumber'
    field name: 'vatNumber'
    field name: 'website'
    field name: 'zip'

    field name: 'attention'
    field name: 'customerContact'
    field name: 'customerGroup'
    field name: 'defaultDeliveryLocation'
    field name: 'invoices'
    field name: 'layout'
    field name: 'paymentTerms'
    field name: 'salesPerson'
    field name: 'templates'
    field name: 'totals'
    field name: 'vatZone'
  end
end
