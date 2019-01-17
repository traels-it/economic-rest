module Economic
  class CustomerRepo < Economic::BaseRepo
    def self.all
      pagination = {}
      pageindex = 0
      customers = []

      # Loop until last page, last page does not have a 'nextPage'
      while pagination['nextPage'] || pageindex.zero?
        response = fetch(endpoint: 'customers', pageindex: pageindex)

        hash = JSON.parse(response.body)
        hash['collection'].each do |customer_hash|
          customers.push Economic::Customer.new(customer_hash)
        end

        pagination = hash['pagination']
        pageindex += 1
      end
      customers
    end

    def self.find(customer_number)
      response = fetch(endpoint: 'customers', page_or_id: customer_number)
      customer_hash = JSON.parse(response.body)
      Economic::Customer.new(customer_hash)
    end
  end
end
