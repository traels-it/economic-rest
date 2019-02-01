module Economic
  class Voucher < Base
    field :voucherNumber, id: true

    field :accountingYear
    field :entries
    field :journal

    #relation:
  end
end
