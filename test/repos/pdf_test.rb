require "test_helper"

module Repos
  class PdfTest < Minitest::Test
    describe "#download_pdf" do
      before { set_credentials }

      it "returns the pdf as a string" do
        stub_request(:get, "https://restapi.e-conomic.com/invoices/booked/9999999/pdf")
          .to_return(status: 200, body: File.read("test/fixtures/pdf/booked_invoice.pdf"))

        pdf = Economic::Models::Pdf.new(download: "https://restapi.e-conomic.com/invoices/booked/9999999/pdf")

        result = Economic::Repos::Pdf.new.download(pdf)

        assert_kind_of String, result
      end
    end
  end
end
