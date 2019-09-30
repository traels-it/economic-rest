module Economic
  class SoapAPI
    URL = "https://api.e-conomic.com/secure/api1/EconomicWebService.asmx?WSDL".freeze

    class << self
      def call(method, message: {})
        response = client.call(method, message: message, cookies: auth_cookies)

        response.body["#{method}_response".to_sym]["#{method}_result".to_sym]
      end

      def auth_cookies
        @auth_cookies ||= client.call(:connect_with_token, message: {token: Economic::Session.agreement_grant_token, appToken: Economic::Session.app_secret_token}).http.cookies
      end

      def client
        @client ||= Savon.client {
          wsdl(URL)
          convert_request_keys_to :none # or one of [:lower_camelcase, :upcase, :none]
        }
      end
    end
  end
end
