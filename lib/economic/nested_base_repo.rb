module Economic
  class NestedBaseRepo < Economic::BaseRepo
    class << self
      def endpoint_url(model)
        Economic::BaseRepo::URL + endpoint_name(model)
      end

      def endpoint_name(model)
        "#{kebab(model.class.name.demodulize.pluralize)}/#{model.id_key}/#{super()}"
      end
    end
  end
end
