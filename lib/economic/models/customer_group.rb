module Economic
  module Models
    class CustomerGroup < Economic::Model
      field :id, as: :customerGroupNumber
      field :account
      field :customers
      field :layout
      field :name
    end
  end
end
