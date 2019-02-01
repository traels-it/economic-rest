module Economic
  class Journal < Base
    field :entries
    field :journalNumber, id: true
    field :name
    field :vouchers, model: :Voucher

    field :settings
    field :templates
  end
end
