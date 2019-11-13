module Economic
  module Invoices
    class Repo < Economic::BaseRepo
      class << self
        def all
          invoices = super
          invoices.each do |invoice|
            invoice.remove_instance_variable("@lines")
            class << invoice
              define_method(:lines) { raise NoMethodError }
            end
          end
          invoices
        end

        def send(model, url: endpoint_url)
          response = send_request(method: :post, url: url, payload: model.to_h.to_json)

          modelize_response(response)
        end
      end
    end
  end
end
