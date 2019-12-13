module Economic
  class DepartmentalDistribution < Base
    field :name
    field :departmentalDistributionNumber, id: true
    field :distributionType

    relation :distributions, fields: [:departmentNumber, :percentage], multiple: true
    relation :customer, fields: [:customerNumber]
    # relation :subCollections, fields: [?]
  end
end
