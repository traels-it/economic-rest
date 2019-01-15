require 'economic/rest/version'
require 'rest-client'

module Economic
  module Rest
    class Demo
      def self.hello
        RestClient.get('https://restapi.e-conomic.com/',
                       'X-AppSecretToken': 'Demo',
                       'X-AgreementGrantToken': 'Demo',
                       'Content-Type': 'application/json')
      end
    end
  end
end
