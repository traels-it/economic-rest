require 'rest-client'
require 'json'
require 'economic/session'

module Economic
  class BaseRepo
    def self.fetch(endpoint:, page_or_id: nil, pageindex: 0)
      url = 'https://restapi.e-conomic.com/'
      url << endpoint.to_s if endpoint
      url << if page_or_id.nil? || page_or_id.to_s.empty?
               "?skippages=#{pageindex}&pagesize=1000"
             else
               "/#{page_or_id}"
             end

      RestClient.get(url,
                     'X-AppSecretToken': Session.app_secret_token,
                     'X-AgreementGrantToken': Session.agreement_grant_token,
                     'Content-Type': 'application/json')
    end
  end
end
