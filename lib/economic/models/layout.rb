module Economic
  module Models
    class Layout < Economic::Model
      field :deleted
      field :id, as: :layoutNumber
      field :name
    end
  end
end
