module Economic
  module Models
    class VatZone < Economic::Model
      field :vat_zone_number
      field :enabled_for_customer
      field :enabled_for_supplier
      field :name
    end
  end
end
