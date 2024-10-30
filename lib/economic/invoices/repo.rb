module Economic
  module Invoices
    class Repo < Economic::BaseRepo
      class << self
        def all(filter_text: "")
          invoices = super(filter_text: filter_text)
          invoices.each do |invoice|
            invoice.remove_instance_variable("@lines")
            class << invoice
              define_method(:lines) { raise NoMethodError }
            end
          end
          invoices
        end

        def save(model, url: endpoint_url)
          response = send_request(method: :post, url: url, payload: model.to_h.to_json)

          modelize_response(response)
        end

        def filter(filter_text)
          all(filter_text: filter_text)
        end
      end
    end
  end
end
