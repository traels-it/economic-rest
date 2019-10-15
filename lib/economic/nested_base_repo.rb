module Economic
  class NestedBaseRepo < Economic::BaseRepo
    class << self
      def endpoint_url(model)
        Economic::BaseRepo::URL + endpoint_name(model)
      end

      def endpoint_name(model)
        "#{kebab(model.class.name.demodulize.pluralize)}/#{model.id_key}/#{super()}"
      end

      def send(model, on: nil)
        response = send_request(method: :post, url: URI.escape(endpoint_url(on)), payload: model.to_h.to_json)

        entry_hash = response.body.blank? ? {} : JSON.parse(response.body)

        model.class.new(entry_hash)
      end
    end
  end
end
