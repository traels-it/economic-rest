module Economic
  class NestedBaseRepo < Economic::BaseRepo
    class << self
      def endpoint_url(model)
        Economic::BaseRepo::URL + endpoint_name(model)
      end

      def endpoint_name(model)
        "#{kebab(model.class.name.demodulize.pluralize)}/#{model.id_key}/#{super()}"
      end

      def send(model, on:)
        response = send_request(method: :post, url: URI.escape(endpoint_url(on)), payload: model.to_h.to_json)

        modelize_response(response, model)
      end

      def save(model, on:)
        post_or_put = model.id_key.nil? ? :post : :put

        response = send_request(method: post_or_put, url: URI.escape(endpoint_url(on) + "/" + model.id_key.to_s), payload: model.to_h.to_json)

        modelize_response(response, model)
      end

      private

      def modelize_response(response, model)
        entry_hash = response.body.blank? ? {} : JSON.parse(response.body)

        model.class.new(entry_hash)
      end
    end
  end
end
