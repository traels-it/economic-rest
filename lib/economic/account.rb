module Economic
  class Account < Base
    field :accountNumber, id: true
    field :accountType
    field :balance
    field :barred
    field :blockDirectEntries
    field :debitCredit
    field :draftBalance
    field :name

    relation :contraAccount, fields: [:accountNumber]
    relation :accountsSummed, fields: [:fromAccount, :toAccount], multiple: true
    relation :totalFromAccount, fields: [:accountNumber]
    relation :vatAccount, fields: [:vatCode]
  end
end
