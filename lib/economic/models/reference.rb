module Economic
  module Models
    class Reference < Economic::Model
      field :other

      relation :customer_contact, klass: "Economic::Models::Customers::Contact"
      relation :sales_person
      relation :vendor_reference
    end
  end
end
