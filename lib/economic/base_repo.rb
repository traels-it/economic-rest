require 'rest-client'
require 'json'

module Economic
  class BaseRepo
    def self.fetch(type, id)
      RestClient.get("https://restapi.e-conomic.com/#{type}/#{id}",
                                'X-AppSecretToken': 'Demo',
                                'X-AgreementGrantToken': 'Demo',
                                'Content-Type': 'application/json')
    end
  end
end
