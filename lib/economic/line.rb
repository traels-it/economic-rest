module Economic
  class Line < Base
    field :lineNumber
    field :description
    field :sortKey
    field :quantity
    field :unitNetPrice
    field :discountPercentage
    field :unitCostPrice
    field :marginInBaseCurrency
    field :marginPercentage
    field :totalNetAmount

    relation :product, fields: [:productNumber]
    relation :unit, fields: [:unitNumber, :name]
    relation :delivery, fields: [:address, :zip, :city, :country, :deliveryDate]
    relation :departmentalDistribution, fields: [:departmentalDistributionNumber, :distributionType]

    def self.build_from_soap_api(data)
      # This is not instantiated with the hash, as lines are never pulled out by themselves, but always as part of
      # a invoice or order
      {
        "lineNumber" => data[:number].to_i,
        "description" => data[:description],
        "quantity" => data[:quantity].to_f,
        "unitNetPrice" => data[:unit_net_price].to_f,
        "discountPercentage" => data[:discount_as_percent].to_f,
        "unitCostPrice" => data[:unit_cost_price].to_f,
        "totalNetAmount" => data[:total_net_amount].to_f,
        "marginPercentage" => data[:margin_as_percent].to_f,
        "marginInBaseCurrency" => data[:total_margin].to_f,
        "product" => {"productNumber" => data[:product_handle][:number]},
        # Unmapped values in soap
        # delivery_date
        # :accrual_start_date => nil,
        # :accrual_end_date => nil
      }
    end
  end
end
