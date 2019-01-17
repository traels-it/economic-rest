require 'rest-client'
require 'json'
require 'economic/session'

module Economic
  class BaseRepo
    def self.fetch(type, id)
      RestClient.get("https://restapi.e-conomic.com/#{type}/#{id}",
                                'X-AppSecretToken': Session.app_secret_token,
                                'X-AgreementGrantToken': Session.agreement_grant_token,
                                'Content-Type': 'application/json')
    end
  end
end
