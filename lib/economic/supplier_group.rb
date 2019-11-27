module Economic
  class SupplierGroup < Base
    field :supplierGroupNumber, id: true
    field :name

    relation :account, fields: [:accountNumber]
  end
end
