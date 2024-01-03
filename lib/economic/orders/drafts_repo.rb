module Economic
  module Orders
    class DraftsRepo < Economic::Orders::Repo
      def self.template(customer)
        response = send_request(method: :get, url: customer.templates["invoice"])

        modelize_response(response)
      end
    end
  end
end
