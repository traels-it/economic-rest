module Economic
  module Models
    class DepartmentalDistribution < Economic::Model
      field :id, as: :departmentalDistributionNumber
      field :name
      field :distribution_type

      relation :customer
      relation :distributions, multiple: true
      # relation :sub_collections
    end
  end
end
