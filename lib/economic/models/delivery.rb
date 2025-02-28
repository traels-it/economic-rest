module Economic
  module Models
    class Delivery < Economic::Model
      field :address
      field :city
      field :country
      field :delivery_date
      field :delivery_terms
      field :zip
    end
  end
end
