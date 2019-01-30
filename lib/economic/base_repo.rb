require 'rest-client'
require 'json'
require 'economic/session'

module Economic
  class BaseRepo
    URL = 'https://restapi.e-conomic.com/'.freeze
    class << self
      def headers
        { 'X-AppSecretToken': Session.app_secret_token, 'X-AgreementGrantToken': Session.agreement_grant_token, 'Content-Type': 'application/json' }
      end

      def fetch(endpoint:, page_or_id: nil, pageindex: 0, filter_text: '')
        url = ''
        url << URL
        url << endpoint.to_s if endpoint
        url << if page_or_id.nil? || page_or_id.to_s.empty?
                 "?skippages=#{pageindex}&pagesize=1000"
               else
                 "/#{page_or_id}"
               end
        url << "&filter=#{filter_text}" unless filter_text == ''
        response = RestClient.get(url, headers)
        test_response(response)
      end

      def save(model)
        url = ''
        url << URL
        url << endpoint_name.to_s if endpoint_name
        url << "/#{model.id_key}"
        response = if model.id_key
                     RestClient.put(url, model.to_h.to_json, headers)
                   else
                     RestClient.post(url, model.to_h.to_json, headers)
                   end
        test_response(response)
      end

      def all(filter_text: '')
        pagination = {}
        pageindex = 0
        entries = []

        # Loop until last page, last page does not have a 'nextPage'
        while pagination['nextPage'] || pageindex.zero?
          response = fetch(endpoint: endpoint_name, pageindex: pageindex, filter_text: filter_text)

          hash = JSON.parse(response.body)
          hash['collection'].each do |entry_hash|
            entries.push model.new(entry_hash)
          end

          pagination = hash['pagination']
          pageindex += 1
        end
        entries
      end

      def filter(filter_text)
        all(filter_text: filter_text)
      end

      def updated_after(date)
        filter("lastUpdated$gt:#{to_iso8601z(date)}")
      end

      def to_iso8601z(date)
        date = date.iso8601
        date = date[0...-5].tr('+', 'Z') if date.include?('+')
        date
      end

      def find(entry_number)
        response = fetch(endpoint: endpoint_name, page_or_id: entry_number)
        entry_hash = JSON.parse(response.body)
        model.new(entry_hash)
      end

      def model
        scopes = name.split('::')
        scopes[1] = scopes[1][0...-1] if scopes.count == 3
        Object.const_get("#{scopes[0]}::#{scopes[1].sub('Repo', '')}")
      end

      def endpoint_name
        end_p = name.sub('Economic::', '')
        if end_p.include?('::')
          end_p = end_p.gsub('Repo', '')
          end_p = end_p.gsub('::', '/')
        else
          end_p = end_p.gsub('Repo', 's')
        end
        end_p.downcase
      end

      def test_response(response)
        raise response if response.code != 200

        response
      end
    end
  end
end
