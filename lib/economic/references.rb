module Economic
  class References < Base
    field :other

    relation :customerContact, fields: [:customerContactNumber]
  end
end
