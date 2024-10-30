module Economic
  module Models
    class Recipient < Economic::Model
      field :address
      field :name
      field :city
      field :country
      field :ean
      field :mobile_phone
      field :public_entry_number
      field :zip

      relation :vat_zone
      relation :attention
    end
  end
end
