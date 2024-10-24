module Economic
  class Resource
    ROOT = "https://restapi.e-conomic.com".freeze
    DEFAULT_QUERY_PARAMS = {skippages: 0, pagesize: 1000}.freeze

    def initialize(credentials: Economic::Credentials.fetch!)
      @credentials = credentials
      raise Economic::MissingCredentialsError if credentials.missing?
    end

    attr_reader :credentials

    def all(filter: nil)
      response = make_request(method: :get, query: {filter:})

      entries = response.collection
      while response.pagination.next_page?
        uri = build_uri(response.pagination.next_page)
        response = make_request(uri:, method: :get)
        entries += response.collection
      end

      entries
    end

    def find(id_or_model)
      make_request(id_or_model:, method: :get).entity
    end

    def create(model)
      make_request(method: :post, data: model).entity
    end

    def update(model)
      make_request(id_or_model: model, method: :put, data: model).entity
    end

    def destroy(id_or_model)
      make_request(id_or_model:, method: :delete)
    end

    private

    def make_request(method:, uri: url, id_or_model: nil, data: nil, query: nil)
      uri = build_uri(uri, id_or_model:, query:)
      request = build_request(uri)
      args = [method, uri, data&.to_json, headers].compact
      response = request.public_send(*args)

      parse_response(response)
    end

    def build_request(uri)
      http = Net::HTTP.new(uri.hostname, Net::HTTP.https_default_port)
      http.use_ssl = true

      http
    end

    def build_uri(uri, id_or_model: nil, query: nil)
      uri = id_or_model.present? ? "#{uri}/#{id_or_model.try(:id) || id_or_model}" : uri
      uri = URI(uri)
      uri.query = URI.encode_www_form(query.with_defaults(DEFAULT_QUERY_PARAMS).compact) if query.present?

      uri
    end

    def parse_response(response)
      case response.code
      when "200"
        Economic::Response.from_json(response.body)
      when "204"
        true
      when "400"
        raise BadRequestError, response.body
      when "401"
        raise UnauthorizedError, response.body
      when "403"
        raise ForbiddenError, response.body
      when "404"
        raise NotFoundError, response.body
      when "500"
        raise InternalError, response.body
      else
        raise Error, "#{response.code} - #{response.body}"
      end
    end

    def url
      "#{ROOT}/#{endpoint}"
    end

    def endpoint
      resource_name.pluralize.underscore.dasherize
    end

    def resource_name
      self.class.to_s[21..-9]
    end

    def headers
      {
        "X-AppSecretToken": credentials.app_secret_token,
        "X-AgreementGrantToken": credentials.agreement_grant_token,
        "Content-Type": "application/json"
      }
    end
  end

  class BadRequestError < StandardError
  end

  class UnauthorizedError < StandardError
  end

  class ForbiddenError < StandardError
  end

  class NotFoundError < StandardError
  end

  class InternalError < StandardError
  end

  class Error < StandardError
  end
end
