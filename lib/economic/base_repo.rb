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

      def fetch(pageindex: 0, filter_text: '')
        url = endpoint_url
        url << "?skippages=#{pageindex}&pagesize=1000"
        url << "&filter=#{filter_text}" unless filter_text == ''

        response = RestClient.get(url, headers)
        test_response(response)
      end

      def save(model)
        post_or_put = model.id_key.nil? ? :post : :put

        response = RestClient.public_send(post_or_put, endpoint_url + '/' + model.id_key.to_s, model.to_h.to_json, headers)

        test_response(response)
      end

      def send(model)
        response = RestClient.post(endpoint_url, model.to_h.to_json, headers)
        test_response(response)
      end

      def all(filter_text: '')
        pagination = {}
        pageindex = 0
        entries = []

        # Loop until last page, last page does not have a 'nextPage'
        while pagination['nextPage'] || pageindex.zero?
          response = fetch(pageindex: pageindex, filter_text: filter_text)

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
        response = test_response(RestClient.get(endpoint_url + '/' + entry_number.to_s, headers))
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
        end_p = end_p.gsub('Journals', 'Journals-Experimental')
        kebab(end_p)
      end

      def endpoint_url
        URL + endpoint_name
      end

      def test_response(response)
        raise response unless response.code.between?(200, 299)

        response
      end

      def kebab(string)
        string.gsub(/::/, '/')
              .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
              .gsub(/([a-z\d])([A-Z])/, '\1_\2')
              .tr('_', '-')
              .downcase
      end
    end
  end
end
