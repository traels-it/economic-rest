require "test_helper"

class Economic::Models::PdfTest < Minitest::Test
  describe Economic::Models::Pdf do
    before { set_credentials }

    describe "#download_pdf" do
      it "returns the pdf as a string" do
        stub_request(:get, "https://restapi.e-conomic.com/invoices/booked/9999999/pdf")
          .to_return(status: 200, body: File.read("test/fixtures/pdf/booked_invoice.pdf"))

        pdf = Economic::Models::Pdf.new(download: "https://restapi.e-conomic.com/invoices/booked/9999999/pdf")
        result = pdf.download_pdf

        assert_kind_of String, result
      end

      it "raises an error, if the pdf has no download url" do
        assert_raises StandardError do
          Economic::Models::Pdf.new.download_pdf
        end
      end
    end
  end
end
