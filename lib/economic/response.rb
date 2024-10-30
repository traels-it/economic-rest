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
          model_class = model_class_from_endpoint(endpoint)

          collection = parsed["collection"].map do |hash|
            # This method is very heavy. It takes about 2 seconds to run test/resources/customer_resource_test.rb:9, which instantiates 3684 customers
            # Not instantiating them results in a runtime of 0.056 seconds.
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
          endpoint = parsed["self"][30..].split("/")[0..-2].join("/")
          model_class = model_class_from_endpoint(endpoint)

          new(
            entity: model_class.from_json(json),
            self_link: parsed["self"],
            meta_data: parsed["metaData"]
          )
        end
      end

      def model_class_from_endpoint(endpoint)
        "Economic::Models::#{endpoint.underscore.tr("0-9", "").gsub("//", "/").classify}".constantize
      end
    end
  end
end
