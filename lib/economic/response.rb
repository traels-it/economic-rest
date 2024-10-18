module Economic
  class Response < Economic::Model
    field :collection
    relation :pagination, klass: "Economic::Response::Pagination"
    field :meta_data
    field :self
    field :entity

    class << self
      def from_json(json)
        parsed = JSON.parse(json)

        if parsed.key?("collection")
          super
        else
          # find model class
          endpoint = parsed["self"][30..].split("/").first
          model_class = "Economic::Models::#{endpoint.classify}".constantize

          new(entity: model_class.from_json(json))
        end
      end
    end
  end
end
