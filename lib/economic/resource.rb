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

      request = build_request(uri)
      response = request.get(uri, headers)
      parsed_response = Economic::Response.from_json(response.body)

      entries = parsed_response.collection

      while parsed_response.pagination.next_page?
        uri = URI(parsed_response.pagination.next_page)
        request = build_request(uri)
        response = request.get(uri, headers)
        parsed_response = Economic::Response.from_json(response.body)
        entries += parsed_response.collection
      end

      entries
    end

    def find(id_or_model)
      id = id_or_model.try(:id) || id_or_model

      uri = URI("#{url}/#{id}")

      request = build_request(uri)
      response = request.get(uri, headers)

      parsed_response = Economic::Response.from_json(response.body)

      parsed_response.entity
    end

    def create(model)
      uri = URI(url)

      request = build_request(uri)
      response = request.post(uri, model.to_json, headers)

      parsed_response = Economic::Response.from_json(response.body)

      parsed_response.entity
    end

    def update(model)
      uri = URI("#{url}/#{model.id}")

      request = build_request(uri)
      response = request.put(uri, model.to_json, headers)
      parsed_response = Economic::Response.from_json(response.body)

      parsed_response.entity
    end

    def destroy(id_or_model)
      id = id_or_model.try(:id) || id_or_model

      uri = URI("#{url}/#{id}")

      request = build_request(uri)
      response = request.delete(uri, headers)

      response.code_type == Net::HTTPNoContent
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

    def model_klass
      "Economic::Models::#{resource_name}".constantize
    end

    def build_request(uri)
      http = Net::HTTP.new(uri.hostname, Net::HTTP.https_default_port)
      http.use_ssl = true

      http
    end
  end
end
