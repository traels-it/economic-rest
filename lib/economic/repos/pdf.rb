module Economic
  module Repos
    class Pdf < Economic::Repo
      def download(model)
        uri = build_uri(model.download)
        request = build_request(uri)

        request.get(uri, headers).body
      end
    end
  end
end
