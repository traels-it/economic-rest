module Economic
  module Models
    class ProductGroup < Economic::Model
      field :name
      field :id, as: :productGroupNumber
      field :sales_accounts
      field :products
    end
  end
end
