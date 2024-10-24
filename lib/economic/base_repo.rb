require "rest-client"
require "json"
require "economic/session"

module Economic
  class BaseRepo
    URL = "https://restapi.e-conomic.com/".freeze

    class << self
      attr_accessor :endpoint

      def save(model, url: endpoint_url)
        if model.id_key.nil?
          post_or_put = :post
        else
          post_or_put = :put
          url += "/" + id_to_url_formatted_id(model.id_key)
        end

        response = send_request(method: post_or_put, url: url, payload: model.to_h.to_json)

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
        url += "/" + id_to_url_formatted_id(id)
        response = send_request(method: :get, url: url)

        entry_hash = JSON.parse(response.body)
        model.new(entry_hash)
      end

      def endpoint_url
        URL + endpoint_name
      end

      def destroy(id, url: endpoint_url)
        url += "/" + id_to_url_formatted_id(id)
        response = send_request(method: :delete, url: url)

        success_codes = [200, 204]
        true if success_codes.include?(response.code)
      end

      def send_request(method:, url:, payload: "", &)
        if payload.strip.empty?
          RestClient::Request.execute(method: method, url: url, headers: headers, &)
        else
          RestClient::Request.execute(method: method, url: url, payload: payload, headers: headers, &)
        end
      rescue => e
        warn "#{e} #{e.response}" if e.respond_to?(:response)
        raise e
      end

      def id_to_url_formatted_id(id)
        id.to_s.gsub("_", "_8_")
          .gsub("<", "_0_")
          .gsub(">", "_1_")
          .gsub("*", "_2_")
          .gsub("%", "_3_")
          .gsub(":", "_4_")
          .gsub("&", "_5_")
          .gsub("/", "_6_")
          .gsub("\\", "_7_")
          .gsub(" ", "_9_")
          .gsub("?", "_10_")
          .gsub(".", "_11_")
          .gsub("#", "_12_")
          .gsub("+", "_13_")
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

      def headers
        {"X-AppSecretToken": Session.app_secret_token, "X-AgreementGrantToken": Session.agreement_grant_token, "Content-Type": "application/json"}
      end

      def fetch(url: endpoint_url, pageindex: 0, filter_text: "")
        url = url.dup
        url << "?skippages=#{pageindex}&pagesize=1000"
        url << "&filter=#{filter_text}" unless filter_text == ""

        send_request(method: :get, url: url)
      end

      def kebab(string)
        string.gsub("::", "/")
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
