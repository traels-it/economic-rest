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

    def self.all
      pagination = {}
      pageindex = 0
      entries = []

      # Loop until last page, last page does not have a 'nextPage'
      while pagination['nextPage'] || pageindex.zero?
        response = fetch(endpoint: endpoint_name, pageindex: pageindex)

        hash = JSON.parse(response.body)
        hash['collection'].each do |entry_hash|
          entries.push model.new(entry_hash)
        end

        pagination = hash['pagination']
        pageindex += 1
      end
      entries
    end

    def self.find(entry_number)
      response = fetch(endpoint: endpoint_name, page_or_id: entry_number)
      entry_hash = JSON.parse(response.body)
      model.new(entry_hash)
    end

    class << self
      def model
        Object.const_get(name.sub('Repo', ''))
      end

      def endpoint_name
        name.sub('Repo', 's').sub('Economic::', '').downcase
      end
    end
  end
end
