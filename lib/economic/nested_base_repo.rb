module Economic
  class NestedBaseRepo < Economic::BaseRepo
    class << self
      def all(filter_text: "", on:)
        super(filter_text: filter_text, url: endpoint_url(on))
      end

      def filter(filter_text, on:)
        all(filter_text: filter_text, on: on)
      end

      def endpoint_url(model)
        Economic::BaseRepo::URL + endpoint_name(model)
      end

      def endpoint_name(model)
        "#{kebab(model.class.name.demodulize.pluralize)}/#{model.id_key}/#{super()}"
      end

      def send(model, on:)
        super(model, url: endpoint_url(on))
      end

      def save(model, on:)
        super(model, url: endpoint_url(on) + "/" + model.id_key.to_s)
      end

      def find(id, on:)
        super(id, url: endpoint_url(on) + "/" + id.to_s)
      end
    end
  end
end
