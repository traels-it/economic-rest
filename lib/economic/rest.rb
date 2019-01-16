require 'economic/rest/version'
require 'rest-client'

Dir.foreach("./lib/economic/") {|x| require "economic/#{x}" if x.include? '.rb' }

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
