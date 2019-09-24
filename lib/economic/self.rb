module Economic
  class Self < Base
    field :agreementNumber
    field :canSendElectronicInvoice
    field :companyAffiliation
    field :modules
    field :signupDate
    field :userName

    # relation :agreementType  object      The type of agreement this is. It can either be denmark, sweden or norway
    # relation :application  object      The company’s bank settings.
    # relation :bankInformation  object      The company’s bank settings.
    relation :company, fields: []
    # relation :settings  object      Other settings.
    # relation :user  object      The currently logged in user.
  end
end
