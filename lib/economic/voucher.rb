module Economic
  class Voucher < Base
    field :voucherNumber, id: true

    field :entries

    relation :journal, fields: [:journalNumber]
    relation :accountingYear, fields: [:year]
  end
end
