module Economic
  class Voucher < Base
    field :voucherNumber, id: true

    field :entries
    field :journal

    relation :accountingYear, fields: [:year]
  end
end
