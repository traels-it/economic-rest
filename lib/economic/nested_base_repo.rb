module Economic
  class NestedBaseRepo < Economic::BaseRepo
    class << self
      def all(filter_text: "", on:)
        super(filter_text: filter_text, url: nested_endpoint_url(on))
      end

      def filter(filter_text, on:)
        all(filter_text: filter_text, on: on)
      end

      def nested_endpoint_url(model)
        Economic::BaseRepo::URL + nested_endpoint_name(model)
      end

      def nested_endpoint_name(model)
        "#{kebab(model.class.name.demodulize.pluralize)}/#{model.id_key}/#{endpoint_name}"
      end

      def send(model, on:)
        super(model, url: nested_endpoint_url(on))
      end

      def save(model, on:)
        super(model, url: nested_endpoint_url(on))
      end

      def find(id, on:)
        super(id, url: nested_endpoint_url(on))
      end

      def destroy(id, on:)
        super(id, url: nested_endpoint_url(on))
      end
    end
  end
end
