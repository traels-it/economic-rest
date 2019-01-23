module Economic
  class Customer < Base
    ATTRIBUTES = %w[address balance barred city contacts corporateIdentificationNumber country creditLimit currency customerNumber deliveryLocations dueAmount ean email lastUpdated name mobilePhone pNumber publicEntryNumber telephoneAndFaxNumber vatNumber website zip].freeze
    OBJECTS = %w[attention customerContact customerGroup defaultDeliveryLocation invoices layout paymentTerms salesPerson templates totals vatZone]
    def id_key
      customerNumber
    end
  end
end
