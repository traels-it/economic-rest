module Economic
  class Customer < Economic::Base
    def self.all
      response = RestClient.get('https://restapi.e-conomic.com/customers',
                     'X-AppSecretToken': 'Demo',
                     'X-AgreementGrantToken': 'Demo',
                     'Content-Type': 'application/json')
      customers_hash = JSON.parse(response.body)['collection']
      curtomers = []

      customers_hash.each do |customer_hash|
        curtomers.push Hashit.new(customer_hash)
      end
      curtomers
    end
  end
end
