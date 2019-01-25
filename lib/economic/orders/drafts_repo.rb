module Economic
  module Orders
    class DraftsRepo < Economic::Orders::Repo
      def self.send(model)
        url = ''
        url << URL
        url << '/orders'
        url << '/sent'
        response = RestClient.post(url, model.to_h.to_json, headers)
        response
      end
    end
  end
end
