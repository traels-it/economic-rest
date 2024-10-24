module Economic
  module Models
    class Reference < Economic::Model
      field :other

      relation :customer_contact
      relation :sales_person
      relation :vendor_reference
    end
  end
end
