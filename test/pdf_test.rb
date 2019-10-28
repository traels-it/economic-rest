require "test_helper"

class PdfTest < Minitest::Test
  describe "#download_pdf" do
    # TODO: Write some better tests
    it "writes the pdf at the supplied path" do
      stub_request(:get, "https://restapi.e-conomic.com/invoices/booked/9999999/pdf")
        .to_return(status: 200, body: File.read("test/fixtures/pdf/booked_invoice.pdf"))
      Economic::Session.authenticate("Demo", "Demo")

      invoice = Economic::Invoice.new("pdf" => {"download" => "https://restapi.e-conomic.com/invoices/booked/9999999/pdf"})
      invoice.pdf.download_pdf(path: "tmp/test.pdf")

      assert Pathname.new("tmp/test.pdf").exist?
    end

    it "returns the pdf as a string if a path is not supplied" do
      stub_request(:get, "https://restapi.e-conomic.com/invoices/booked/9999999/pdf")
        .to_return(status: 200, body: File.read("test/fixtures/pdf/booked_invoice.pdf"))
      Economic::Session.authenticate("Demo", "Demo")

      invoice = Economic::Invoice.new("pdf" => {"download" => "https://restapi.e-conomic.com/invoices/booked/9999999/pdf"})
      result = invoice.pdf.download_pdf

      assert_kind_of String, result
    end

    it "raises an error, if the pdf has no download url" do
      assert_raises StandardError do
        Economic::Pdf.new.download_pdf
      end
    end
  end
end
