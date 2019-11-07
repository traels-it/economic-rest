module Economic
  class References < Base
    field :other

    relation :customerContact, fields: [:customerContactNumber]
    relation :salesPerson, fields: [:employeeNumber]
    relation :vendorReference, fields: [:employeeNumber]
  end
end
