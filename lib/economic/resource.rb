module Economic
  class Resource
    ROOT = "https://restapi.e-conomic.com".freeze

    def initialize(credentials: Economic::Credentials.fetch!)
      @credentials = credentials
      raise Economic::MissingCredentialsError if credentials.missing?
    end

    attr_reader :credentials

    def all(filter: nil)
      get(url, filter:)
    end

    def find(id_or_model)
      id = id_or_model.try(:id) || id_or_model
      uri = URI("#{url}/#{id}")

      response = send_request(uri)

      model_klass.from_json(response.entry.to_json)
    end

    def url
      "#{ROOT}/#{endpoint}"
    end

    def endpoint
      resource_name.pluralize.underscore.dasherize
    end

    def resource_name
      self.class.to_s.demodulize[0..-9]
    end

    def headers
      {
        "X-AppSecretToken": credentials.app_secret_token,
        "X-AgreementGrantToken": credentials.agreement_grant_token,
        "Content-Type": "application/json"
      }
    end

    private

    def get(url, **params)
      uri = URI(url)
      default_params = {skippages: 0, pagesize: 1000}
      uri.query = URI.encode_www_form(params.with_defaults(default_params).compact)

      response = send_request(uri)
      entries = parse(response.collection)

      while response.next_page?
        response = send_request(response.next_page)
        entries += parse(response.collection)
      end

      entries
    end

    def parse(collection)
      collection.map do |item|
        model_klass.from_json(item.to_json)
      end
    end

    def model_klass
      "Economic::Models::#{resource_name}".constantize
    end

    def send_request(uri)
      response = Net::HTTP.get(uri, headers)
      parsed = JSON.parse(response)
      next_page_data = parsed.dig("pagination", "nextPage")
      next_page = next_page_data.nil? ? nil : URI(next_page_data)
      collection = parsed.dig("collection")
      entry = parsed

      Response.new(
        next_page:,
        collection:,
        entry:
      )
    end
  end

  class Response < Data.define(:next_page, :collection, :entry)
    def next_page?
      next_page.present?
    end
  end
end
