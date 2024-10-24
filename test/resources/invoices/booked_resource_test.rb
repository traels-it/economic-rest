require "test_helper"

module Resources
  module Invoices
    class BookedResourceTest < Minitest::Test
      describe Economic::Resources::Invoices::BookedResource do
        before { set_credentials }

        describe "#create" do
          it "books draft invoice" do
            stub_request(:post, "https://restapi.e-conomic.com/invoices/booked")
              .with(
                body: {draftInvoice: {draftInvoiceNumber: 148}}
              ).to_return(status: 200, body: File.read(json_fixture("create_booked_invoice")), headers: {})

            booked_invoice = Economic::Models::Invoices::Booked.new(
              draft_invoice: Economic::Models::Invoices::Draft.new(
                id: 148
              )
            )

            created_invoice = Economic::Resources::Invoices::BookedResource.new.create(booked_invoice)

            assert_instance_of Economic::Models::Invoices::Booked, created_invoice
            assert_equal 31, created_invoice.id
            refute created_invoice.lines.empty?
          end
        end
      end
    end
  end
end
