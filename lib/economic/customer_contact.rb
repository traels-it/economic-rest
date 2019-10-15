module Economic
  class CustomerContact < Base
    field :customerContactNumber, id: true
    field :deleted
    field :eInvoiceId
    field :email
    # field :emailNotifications - is an array
    field :name
    field :notes
    field :phone
    field :sortKey

    relation :customer, fields: [:customerNumber]
  end
end
