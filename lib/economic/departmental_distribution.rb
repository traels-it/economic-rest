module Economic
  class DepartmentalDistribution < Base
    field :name
    field :departmentalDistributionNumber, id: true
    field :distributionType

    relation :customer, fields: []
    relation :distributions, fields: [], multiple: true
    # relation :subCollections, fields: [?]
  end
end
