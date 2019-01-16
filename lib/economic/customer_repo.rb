module Economic
  class CustomerRepo < Economic::BaseRepo
    def self.all
      response = fetch('customers', '')
      customers_hash = JSON.parse(response.body)['collection']
      curtomers = []

      customers_hash.each do |customer_hash|
        curtomers.push Economic::Customer.new(customer_hash)
      end
      curtomers
    end

    def self.find(customer_number)
      response = fetch('customers', customer_number)
      customer_hash = JSON.parse(response.body)
      Economic::Customer.new(customer_hash)
    end
  end
end
