module Economic
  module Models
    class Pdf < Economic::Model
      field :self
      field :download

      def download_pdf
        raise StandardError, "There is no download url set" if download.nil?

        Net::HTTP.get(URI(download))
      end
    end
  end
end
