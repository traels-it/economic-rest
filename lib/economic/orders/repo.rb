module Economic
  module Orders
    class Repo < Economic::BaseRepo
      class << self
        def all
          orders = super
          orders.each do |order|
            order.remove_instance_variable("@lines")
            class << order
              define_method(:lines) { raise NoMethodError }
            end
          end
          orders
        end

        def send(model, url: endpoint_url)
          response = send_request(method: :post, url: url, payload: model.to_h.to_json)

          modelize_response(response)
        end
      end
    end
  end
end
