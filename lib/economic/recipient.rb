module Economic
  class Recipient < Base
    field :address
    field :name
    field :city
    field :country
    field :ean
    field :mobilePhone
    field :publicEntryNumber

    relation :vatZone, fields: []
    relation :attention, fields: []
  end
end
