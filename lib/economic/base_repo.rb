require 'rest-client'
require 'json'
require 'economic/session'

module Economic
  class BaseRepo
    def self.fetch(endpoint, page_or_id)
      url = 'https://restapi.e-conomic.com/'
      url << "#{endpoint}" if endpoint
      url << "/#{page_or_id}" unless page_or_id.nil? || page_or_id.to_s.empty?

      RestClient.get(url,
                     'X-AppSecretToken': Session.app_secret_token,
                     'X-AgreementGrantToken': Session.agreement_grant_token,
                     'Content-Type': 'application/json')
    end
  end
end
