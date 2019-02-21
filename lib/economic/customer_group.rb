module Economic
  class CustomerGroup < Base
    field :account
    field :customerGroupNumber, id: true
    field :customers
    field :layout
    field :name
  end
end
