module Economic
  class Recipient < Base
    field :address
    field :name
    field :ean

    relation :vatZone, fields: []
  end
end
