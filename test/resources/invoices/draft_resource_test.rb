require "test_helper"

module Resources
  module Invoices
    class DraftResourceTest < Minitest::Test
      describe Economic::Resources::Invoices::DraftResource do
        before { set_credentials }

        describe "#all" do
          it "returns all invoices" do
            stub_get_request(endpoint: "invoices/drafts", skippages: 0, fixture_name: "invoices_0")

            invoices = Economic::Resources::Invoices::DraftResource.new.all
            invoice = invoices.first

            assert_kind_of Economic::Models::Invoice, invoice
            assert_equal 19, invoice.id
            assert_equal 2, invoices.length
          end
        end
      end
    end
  end
end
