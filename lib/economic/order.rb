module Economic
  class Order < Base
    field :attachment #skriv som symbol
    field :costPriceInBaseCurrency
    field :currency
    field :date
    field :dueDate
    field :exchangeRate
    field :grossAmount
    field :grossAmountInBaseCurrency
    field :lines
    field :marginInBaseCurrency
    field :marginPercentage
    field :netAmount
    field :netAmountInBaseCurrency
    field :orderNumber, id: true
    field :roundingAmount
    field :vatAmount

    field :customer
    field :delivery
    field :notes
    field :paymentTerms
    field :pdf
    field :project
    field :recipient
    field :references
    field :templates


    # ud med dem
    def move_to_drafts
      Economic::Orders::Repo.post self, 'drafts'
    end

    def move_to_sent
      Economic::Orders::Repo.post self, 'sent'
    end
    # end ud med dem
  end
end
