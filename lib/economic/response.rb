module Economic
  class Response
    def initialize(self_link:, meta_data:, pagination: nil, collection: nil, entity: nil)
      @self_link = self_link
      @meta_data = meta_data
      @pagination = pagination
      @collection = collection
      @entity = entity
    end

    attr_accessor :self_link, :meta_data, :pagination, :collection, :entity

    class << self
      def from_json(json)
        parsed = JSON.parse(json)

        if parsed.key?("collection")
          endpoint = parsed["self"][30..].split("?").first
          model_class = "Economic::Models::#{endpoint.underscore.classify}".constantize

          collection = parsed["collection"].map do |hash|
            model_class.from_hash(hash)
          end

          new(
            collection: collection,
            meta_data: parsed["metaData"],
            self_link: parsed["self"],
            pagination: Economic::Response::Pagination.from_hash(parsed["pagination"])
          )
        else
          # find model class
          endpoint = parsed["self"][30..].split("/").first
          model_class = "Economic::Models::#{endpoint.underscore.classify}".constantize

          new(
            entity: model_class.from_json(json),
            self_link: parsed["self"],
            meta_data: parsed["metaData"]
          )
        end
      end
    end
  end
end