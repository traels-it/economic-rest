module Economic
  module Orders
    class SentRepo < Economic::Orders::Repo
      def self.send(model)
        url = ''
        url << URL
        url << 'orders'
        url << '/sent'
        response = RestClient.post(url, model.to_h.to_json, headers) do |response, _request, _result|
          response
        end
        test_response(response)
      end
    end
  end
end
