module Economic
  class Customer < Base
    ATTRIBUTES = %w[address balance barred city contacts corporateIdentificationNumber country creditLimit currency customerNumber deliveryLocations ean email lastUpdated name pNumber publicEntryNumber telephoneAndFaxNumber vatNumber website zip].freeze
  end
end
