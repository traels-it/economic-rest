module Economic
  class References < Base
    field :other

    relation :customerContact, fields: [:customerContactNumber]
    relation :salesPerson, fields: [:employeeNumber]
    relation :vendorReferences, fields: [:employeeNumber]
  end
end
