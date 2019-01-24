module Economic
  module Orders
    class Repo < Economic::BaseRepo
      def self.post(model, endpoint)
        url = ''
        url << URL
        url << '/orders'
        url << "/#{endpoint}"
        response = RestClient.post(url, model.to_h.to_json, headers)
        response
      end
    end
  end
end
