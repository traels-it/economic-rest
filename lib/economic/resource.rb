module Economic
  class Resource
    ROOT = "https://restapi.e-conomic.com".freeze

    def all
      get(url)
    end

    def url
      "#{ROOT}/#{endpoint}"
    end

    def endpoint
      resource_name.pluralize.underscore.dasherize
    end

    def resource_name
      self.class.to_s.demodulize[0..-("Resource".length + 1)]
    end

    private

    def get(url, pageindex: 0)
      transformed_url = "#{url}?skippages=#{pageindex}&pagesize=1000"

      parse(RestClient.get(transformed_url))
    end

    def parse(response)
      JSON.parse(response).dig("collection").map do |item|
        model_klass.from_json(item.to_json)
      end
    end

    def model_klass
      "Economic::Models::#{resource_name}".constantize
    end
  end
end
