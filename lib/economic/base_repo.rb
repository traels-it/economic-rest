require "rest-client"
require "json"
require "economic/session"

module Economic
  class BaseRepo
    URL = "https://restapi.e-conomic.com/".freeze

    class << self
      attr_accessor :endpoint

      def save(model, url: endpoint_url)
        post_or_put = model.id_key.nil? ? :post : :put
        url += "/" + model.id_key.to_s

        response = send_request(method: post_or_put, url: url, payload: model.to_h.to_json)

        modelize_response(response)
      end

      # TODO: This method does not seem to do anything that the save method cannot do - is there any reason to keep it? Posting to a not-existing id is apparenly fine
      def send(model, url: endpoint_url)
        response = send_request(method: :post, url: url, payload: model.to_h.to_json)

        modelize_response(response)
      end

      def all(filter_text: "", url: endpoint_url)
        pagination = {}
        pageindex = 0
        entries = []

        # Loop until last page, last page does not have a 'nextPage'
        while pagination["nextPage"] || pageindex.zero?
          response = fetch(url: url, pageindex: pageindex, filter_text: filter_text)

          hash = JSON.parse(response.body)
          hash["collection"].each do |entry_hash|
            entries.push model.new(entry_hash)
          end

          pagination = hash["pagination"]
          pageindex += 1
        end
        entries
      end

      def filter(filter_text, url: endpoint_url)
        all(filter_text: filter_text, url: url)
      end

      def updated_after(date)
        filter("lastUpdated$gt:#{to_iso8601z(date)}")
      end

      def find(id, url: endpoint_url)
        url += "/" + id.to_s
        response = send_request(method: :get, url: url)

        entry_hash = JSON.parse(response.body)
        model.new(entry_hash)
      end

      def endpoint_url
        URL + endpoint_name
      end

      def destroy(id, url: endpoint_url)
        url += "/" + id.to_s
        response = send_request(method: :delete, url: url)

        # The response to a delete action looks different, depending on the end point. For instance, all the
        # delete actions for the customer endpoint returns a 204 with an empty body, while deleting a draft
        # invoice returns a 200 with a message detailing the items deleted
        success_codes = [200, 204]
        return true if success_codes.include?(response.code)
      end

      private

      def model
        scopes = name.split("::")
        scopes[1] = scopes[1][0...-1] if scopes.count == 3
        Object.const_get("#{scopes[0]}::#{scopes[1].sub("Repo", "")}")
      end

      def endpoint_name
        return endpoint unless endpoint.nil?

        end_p = name.sub("Economic::", "")
        if end_p.include?("::")
          end_p = end_p.gsub("Repo", "")
          end_p = end_p.gsub("::", "/")
        else
          end_p = end_p.gsub("Repo", "s")
        end
        kebab(end_p)
      end

      def to_iso8601z(date)
        date = date.iso8601
        date = date[0...-5].tr("+", "Z") if date.include?("+")
        date
      end

      def send_request(method:, url:, payload: "", &block)
        url = URI.escape(url)
        if payload.strip.empty?
          RestClient::Request.execute(method: method, url: url, headers: headers, &block)
        else
          RestClient::Request.execute(method: method, url: url, payload: payload, headers: headers, &block)
        end
      rescue => e
        raise "#{e}#{e.respond_to?(:response) ? ": #{e.response}" : ""}"
      end

      def headers
        {'X-AppSecretToken': Session.app_secret_token, 'X-AgreementGrantToken': Session.agreement_grant_token, 'Content-Type': "application/json"}
      end

      def fetch(url: endpoint_url, pageindex: 0, filter_text: "")
        url = url.dup
        url << "?skippages=#{pageindex}&pagesize=1000"
        url << "&filter=#{filter_text}" unless filter_text == ""

        send_request(method: :get, url: url)
      end

      def kebab(string)
        string.gsub(/::/, "/")
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr("_", "-")
          .downcase
      end

      def modelize_response(response)
        entry_hash = response.body.blank? ? {} : JSON.parse(response.body)

        model.new(entry_hash)
      end
    end
  end
end
