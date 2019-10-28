require "test_helper"

class BookedInvoiceRepoTest < Minitest::Test
  describe "#send" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end

    it "books a draft invoice" do
      stub_get_request(endpoint: "invoices/booked", fixture_name: "invoice_book", method: :post, paged: false)

      booked_invoice = Economic::Invoices::BookedRepo.send(Economic::Invoice.new)

      assert_kind_of Economic::Invoice, booked_invoice
      assert_equal 10, booked_invoice.booked_invoice_number
    end

    it "can book an invoice with a specific supplied number" do
      stub_get_request(endpoint: "invoices/booked", fixture_name: "invoice_book_with_number", method: :post, paged: false)

      booked_invoice = Economic::Invoices::BookedRepo.send(Economic::Invoice.new, book_with_number: 9999999)

      assert_kind_of Economic::Invoice, booked_invoice
      assert_equal 9999999, booked_invoice.booked_invoice_number
    end
  end
end
