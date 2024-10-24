module Economic
  module Invoices
    class DraftsRepo < Economic::Invoices::Repo
      def self.template(customer)
        response = send_request(method: :get, url: customer.templates["invoice"])

        modelize_response(response)
      end
    end

    deprecate_constant :DraftsRepo
  end
end
