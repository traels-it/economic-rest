module Economic
  class SelfRepo < Economic::BaseRepo
    def self.self
      response = send_request(method: :get, url: URI.escape(Economic::SelfRepo.endpoint_url))
      entry_hash = JSON.parse(response.body)
      model.new(entry_hash)
    end
  end
end