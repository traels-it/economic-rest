require "test_helper"

module Repos
  module Invoices
    class DraftTest < Minitest::Test
      describe Economic::Repos::Invoices::Draft do
        before { set_credentials }

        describe "#all" do
          it "returns all invoices" do
            stub_get_request(endpoint: "invoices/drafts", skippages: 0, fixture_name: "invoices_0")

            invoices = Economic::Repos::Invoices::Draft.new.all
            invoice = invoices.first

            assert_instance_of Economic::Models::Invoices::Draft, invoice
            assert_equal 4, invoice.id
            assert_equal 9, invoices.length
          end
        end

        describe "#create" do
          it "creates a new draft invoice" do
            stub_request(:post, "https://restapi.e-conomic.com/invoices/drafts")
              .with(
                body: {currency: "DKK", date: "2014-08-08", grossAmount: 12.5, marginInBaseCurrency: -46.93, marginPercentage: 0.0, netAmount: 10.0, roundingAmount: 0.0, vatAmount: 2.5, costPriceInBaseCurrency: 46.93, netAmountInBaseCurrency: 0.0, customer: {customerNumber: 1}, paymentTerms: {paymentTermsNumber: 1}, recipient: {address: "Vejlevej 21", name: "Toj & Co Grossisten", city: "Fredericia", zip: "7000", vatZone: {vatZoneNumber: 1, enabledForCustomer: true, enabledForSupplier: true, name: "Domestic"}}, references: {other: "Custom reference"}, layout: {layoutNumber: 20}}
              )
              .to_return(status: 200, body: File.read(json_fixture("create_draft_invoice")), headers: {})

            payment_terms = Economic::Models::PaymentTerm.new(
              payment_terms_number: 1
            )
            customer = Economic::Models::Customer.new(
              id: 1
            )
            vat_zone = Economic::Models::VatZone.new(
              name: "Domestic",
              vat_zone_number: 1,
              enabled_for_customer: true,
              enabled_for_supplier: true
            )
            recipient = Economic::Models::Recipient.new(
              name: "Toj & Co Grossisten",
              address: "Vejlevej 21",
              zip: "7000",
              city: "Fredericia",
              vat_zone:
            )
            references = Economic::Models::Reference.new(
              other: "Custom reference"
            )
            layout = Economic::Models::Layout.new(
              id: 20
            )
            invoice = Economic::Models::Invoices::Draft.new(
              date: "2014-08-08",
              currency: "DKK",
              net_amount: 10.00,
              net_amount_in_base_currency: 0.00,
              gross_amount: 12.50,
              margin_in_base_currency: -46.93,
              margin_percentage: 0.0,
              vat_amount: 2.50,
              rounding_amount: 0.00,
              cost_price_in_base_currency: 46.93,
              payment_terms:,
              customer:,
              recipient:,
              references:,
              layout:
            )

            created_invoice = Economic::Repos::Invoices::Draft.new.create(invoice)

            assert_instance_of Economic::Models::Invoices::Draft, created_invoice
            assert_equal 148, created_invoice.id
          end
        end
      end
    end
  end
end
