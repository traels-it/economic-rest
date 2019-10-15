require "rest-client"
require "json"
require "economic/session"

module Economic
  class BaseRepo
    URL = "https://restapi.e-conomic.com/".freeze

    class << self
      def save(model)
        post_or_put = model.id_key.nil? ? :post : :put

        send_request(method: post_or_put, url: URI.escape(endpoint_url + "/" + model.id_key.to_s), payload: model.to_h.to_json)
      end

      def send(model)
        response = send_request(method: :post, url: URI.escape(endpoint_url), payload: model.to_h.to_json)

        entry_hash = response.body.blank? ? {} : JSON.parse(response.body)

        model.class.new(entry_hash)
      end

      def all(filter_text: "", url: nil)
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

      def filter(filter_text)
        all(filter_text: filter_text)
      end

      def updated_after(date)
        filter("lastUpdated$gt:#{to_iso8601z(date)}")
      end

      def find(id)
        response = send_request(method: :get, url: endpoint_url + "/" + id.to_s)
        entry_hash = JSON.parse(response.body)
        model.new(entry_hash)
      end

      def endpoint_url
        URL + endpoint_name
      end

      def destroy(id)
        response = send_request(method: :delete, url: endpoint_url + "/" + id.to_s)

        JSON.parse(response.body)["message"] == "Deleted #{model.to_s.split("::").last.downcase}."
      end

      private

      def model
        scopes = name.split("::")
        scopes[1] = scopes[1][0...-1] if scopes.count == 3
        Object.const_get("#{scopes[0]}::#{scopes[1].sub("Repo", "")}")
      end

      def endpoint_name
        end_p = name.sub("Economic::", "")
        if end_p.include?("::")
          end_p = end_p.gsub("Repo", "")
          end_p = end_p.gsub("::", "/")
        else
          end_p = end_p.gsub("Repo", "s")
        end
        end_p = end_p.gsub("Journals", "Journals-Experimental")
        end_p = end_p.gsub("Selfs", "Self")
        # PaymentTerms is named with a plural s for a single record, but the end point is still just paymentterms.
        # Therefore the endpoint gets substituted
        end_p = end_p.gsub("PaymentTermss", "PaymentTerms")
        end_p = end_p.gsub("CustomerContacts", "Contacts")
        kebab(end_p)
      end

      def to_iso8601z(date)
        date = date.iso8601
        date = date[0...-5].tr("+", "Z") if date.include?("+")
        date
      end

      def send_request(method:, url:, payload: "", &block)
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

      def fetch(url:, pageindex: 0, filter_text: "")
        url = url.nil? ? endpoint_url : url
        url << "?skippages=#{pageindex}&pagesize=1000"
        url << "&filter=#{filter_text}" unless filter_text == ""

        send_request(method: :get, url: URI.escape(url))
      end

      def kebab(string)
        string.gsub(/::/, "/")
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr("_", "-")
          .downcase
      end
    end
  end
end
