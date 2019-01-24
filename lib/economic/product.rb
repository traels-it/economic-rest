module Economic
  class Product < Base
    field name: 'barCode'
    field name: 'barred'
    field name: 'costPrice'
    field name: 'description'
    field name: 'lastUpdated'
    field name: 'name'
    field name: 'productNumber', id: true
    field name: 'recommendedPrice'
    field name: 'salesPrice'

    field name: 'departmentalDistribution'
    field name: 'inventory'
    field name: 'invoices'
    field name: 'pricing'
    field name: 'productGroup'
    field name: 'unit'
  end
end
