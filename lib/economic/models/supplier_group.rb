module Economic
  module Models
    class SupplierGroup < Economic::Model
      field :id, as: :supplierGroupNumber
      field :name

      relation :account
    end
  end
end
