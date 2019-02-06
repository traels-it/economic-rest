module Economic
  class Recipient < Base
    field :address
    field :name

    relation :vatZone, fields: []
  end
end
