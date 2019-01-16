require 'economic/rest/version'
require 'rest-client'

require 'economic/base_repo'
require 'economic/base'
require 'economic/customer_repo'
require 'economic/customer'
require 'economic/product_repo'
require 'economic/product'


module Economic
  class Demo
    def self.hello
      RestClient.get('https://restapi.e-conomic.com/',
                     'X-AppSecretToken': 'Demo',
                     'X-AgreementGrantToken': 'Demo',
                     'Content-Type': 'application/json')
    end
  end
end
