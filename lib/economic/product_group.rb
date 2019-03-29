module Economic
  class ProductGroup < Base
    field :name
    field :productGroupNumber, id: true
    field :salesAccounts
    field :products
  end
end
