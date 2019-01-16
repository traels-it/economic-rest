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

    def self.find(customer_number)
      response = RestClient.get("https://restapi.e-conomic.com/customers/#{customer_number}",
                                'X-AppSecretToken': 'Demo',
                                'X-AgreementGrantToken': 'Demo',
                                'Content-Type': 'application/json')
      customer_hash = JSON.parse(response.body)
      Hashit.new(customer_hash)
    end
  end
end
