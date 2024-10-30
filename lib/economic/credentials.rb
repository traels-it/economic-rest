module Economic
  class Credentials < Data.define(:app_secret_token, :agreement_grant_token)
    class << self
      def fetch!
        credentials = new(
          app_secret_token: Economic::Configuration.app_secret_token,
          agreement_grant_token: Economic::Configuration.agreement_grant_token
        )

        raise MissingCredentialsError if credentials.missing?

        credentials
      end
    end

    def missing?
      app_secret_token.nil? || agreement_grant_token.nil?
    end
  end

  class MissingCredentialsError < StandardError
    def message
      "Credentials missing! Initialize the resource with a set of credentials or set them on Economic::Configuration"
    end
  end
end
