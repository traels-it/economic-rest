module Economic
  class Recipient < Base
    field :address
    field :name
    field :city
    field :country
    field :ean
    field :mobilePhone
    field :publicEntryNumber
    field :zip

    relation :vatZone, fields: []
    relation :attention, fields: []
  end
end
