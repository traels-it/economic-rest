module Economic
  module Orders
    class SentRepo < Economic::Orders::Repo
      def self.send(model)
        url = ''
        url << URL
        url << '/orders'
        url << '/drafts'
        response = RestClient.post(url, model.to_h.to_json, headers)
        response
      end
    end
  end
end
