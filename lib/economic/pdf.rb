module Economic
  class Pdf < Base
    field :self
    field :download

    def download_pdf(path: nil)
      raise StandardError, "There is no download url set" if download.nil?

      response = Economic::BaseRepo.send_request(method: :get, url: download)

      return response.body if path.nil?

      dirname = File.dirname(path)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
      File.open(path, "wb") { |f| f.puts response.body }
    end
  end
end
