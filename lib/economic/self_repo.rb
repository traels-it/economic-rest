module Economic
  class SelfRepo < Economic::BaseRepo
    self.endpoint = "self"

    class << self
      def self
        response = send_request(method: :get, url: Economic::SelfRepo.endpoint_url)
        entry_hash = JSON.parse(response.body)
        model.new(entry_hash)
      end
    end
  end
end
