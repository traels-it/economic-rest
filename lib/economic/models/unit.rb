module Economic
  module Models
    class Unit < Economic::Model
      field :id, as: :unitNumber
      field :name
    end
  end
end
