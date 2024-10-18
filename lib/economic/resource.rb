module Economic
  class Resource
    ROOT = "https://restapi.e-conomic.com".freeze
    DEFAULT_ALL_PARAMS = {skippages: 0, pagesize: 1000}.freeze

    def initialize(credentials: Economic::Credentials.fetch!)
      @credentials = credentials
      raise Economic::MissingCredentialsError if credentials.missing?
    end

    attr_reader :credentials

    def all(filter: nil)
      uri = URI(url)
      uri.query = URI.encode_www_form({filter:}.with_defaults(DEFAULT_ALL_PARAMS).compact)

      parsed_response = make_request(uri:, method: :get)

      entries = parsed_response.collection

      while parsed_response.pagination.next_page?
        uri = URI(parsed_response.pagination.next_page)
        parsed_response = make_request(uri:, method: :get)
        entries += parsed_response.collection
      end

      entries
    end

    def find(id_or_model)
      id = id_or_model.try(:id) || id_or_model

      uri = URI("#{url}/#{id}")

      parsed_response = make_request(uri:, method: :get)

      parsed_response.entity
    end

    def create(model)
      uri = URI(url)

      parsed_response = make_request(uri:, method: :post, data: model)

      parsed_response.entity
    end

    def update(model)
      uri = URI("#{url}/#{model.id}")

      parsed_response = make_request(uri:, method: :put, data: model)

      parsed_response.entity
    end

    def destroy(id_or_model)
      id = id_or_model.try(:id) || id_or_model

      uri = URI("#{url}/#{id}")

      make_request(uri:, method: :delete)
    end

    private

    def make_request(uri:, method:, data: nil)
      request = build_request(uri)
      args = [method, uri, data&.to_json, headers].compact
      response = request.public_send(*args)

      if response.code_type == Net::HTTPNoContent
        true
      else
        Economic::Response.from_json(response.body)
      end
    end

    def build_request(uri)
      http = Net::HTTP.new(uri.hostname, Net::HTTP.https_default_port)
      http.use_ssl = true

      http
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
  end
end
