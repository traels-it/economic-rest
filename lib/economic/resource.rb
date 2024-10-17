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
      transformed_url = uri

      response = Net::HTTP.get(transformed_url, headers)

      parse(response)
    end

    def parse(response)
      JSON.parse(response).dig("collection").map do |item|
        model_klass.from_json(item.to_json)
      end
    end

    def model_klass
      "Economic::Models::#{resource_name}".constantize
    end
  end
end
