require "test_helper"

class InvoiceRepoTest < Minitest::Test
  describe "For invoice" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end

    describe "find" do
      it "can find draft by id" do
        stub_get_request(endpoint: "invoices/drafts", page_or_id: "19", fixture_name: "invoice")

        draft = Economic::Invoices::DraftsRepo.find(19)

        assert_equal "DKK", draft.to_h["currency"]
        assert_equal "DKK", draft.currency
        assert_equal 15, draft.layout.layout_number
        assert_kind_of Economic::Invoice, draft
      end

      it "can find draft with lines" do
        stub_get_request(endpoint: "invoices/drafts", page_or_id: "19", fixture_name: "invoice")

        draft = Economic::Invoices::DraftsRepo.find(19)

        assert_equal 2, draft.lines.size
        assert_equal 2.00, draft.lines[1].quantity
        assert_kind_of Economic::Line, draft.lines.first
        assert_kind_of Economic::Invoice, draft
      end
    end

    describe "all" do
      it "can find all drafts" do
        stub_get_request(endpoint: "invoices/drafts", skippages: 0, fixture_name: "invoices_0")

        drafts = Economic::Invoices::DraftsRepo.all

        assert_equal 9, drafts.size
        assert_kind_of Economic::Invoice, drafts.first
      end
    end

    describe "save" do
      it "can post" do
        stub_get_request(endpoint: "invoices/drafts", fixture_name: "invoice_send", method: :post, paged: false)

        draft = Economic::Invoice.new({})
        draft.currency = "DKK"
        draft.customer.name = "Torstens Torskebutik"
        draft.exchange_rate = 100.00000
        draft.customer.customer_number = 1
        draft.date = Date.today
        draft.due_date = Date.today.next_day
        draft.layout.layout_number = 19
        draft.recipient.name = "Torstens Torskebutik"
        draft.recipient.address = "Hejrevej 1"
        draft.recipient.vat_zone.vat_zone_number = 1
        draft.payment_terms.payment_terms_number = 1
        draft.delivery.address = "Rødspætteallé 3"
        draft.delivery.city = "Esbjerg"
        draft.delivery.country = "Danmark"
        draft.delivery.delivery_date = Date.today
        draft.delivery.zip = "1234"
        draft.notes.heading = "Dette er en overskrift"
        draft.net_amount = 123.21
        draft.vat_amount = 12.12
        draft.gross_amount = 100.00
        draft.margin_in_base_currency = 0
        draft.margin_percentage = 0
        draft.lines = [
          Economic::Line.new({
            "lineNumber" => 5,
            "description" => "Frisk torsk - med rogn",
            "unit" => {"unitNumber" => 1},
            "product" => {"productNumber" => "1"},
            "quantity" => 3.0,
            "unitNetPrice" => 153.44,
            "discountPercentage" => 10,
            "unitCostPrice" => 10.2,
            "marginInBaseCurrency" => 0,
            "marginPercentage" => 0
          }),
          Economic::Line.new({
            "lineNumber" => 5,
            "description" => "Helleflynder",
            "unit" => {"unitNumber" => 1},
            "product" => {"productNumber" => "3"},
            "quantity" => 2.0,
            "unitNetPrice" => 23.00,
            "discountPercentage" => 0,
            "unitCostPrice" => 10.22,
            "marginInBaseCurrency" => 0,
            "marginPercentage" => 0
          })
        ]

        response = Economic::Invoices::DraftsRepo.save draft

        assert_kind_of Economic::Invoice, response
      end

      it "creates a recipient properly" do
        stub_get_request(endpoint: "invoices/drafts", fixture_name: "invoice_send", method: :post, paged: false)

        draft = Economic::Invoice.new({})
        draft.currency = "DKK"
        draft.customer.name = "Torstens Torskebutik"
        draft.exchange_rate = 100.00000
        draft.customer.customer_number = 1
        draft.date = Date.today
        draft.due_date = Date.today.next_day
        draft.layout.layout_number = 19
        draft.recipient.name = "Torstens Torskebutik"
        draft.recipient.address = "Hejrevej 1"
        draft.recipient.city = "Byen"
        draft.recipient.zip = "1234"
        draft.recipient.country = "Danmark"
        draft.recipient.public_entry_number = "nummer 1"
        draft.recipient.vat_zone.vat_zone_number = 1
        draft.payment_terms.payment_terms_number = 1
        draft.delivery.address = "Rødspætteallé 3"
        draft.delivery.city = "Esbjerg"
        draft.delivery.country = "Danmark"
        draft.delivery.delivery_date = Date.today
        draft.delivery.zip = "1234"
        draft.notes.heading = "Dette er en overskrift"
        draft.net_amount = 123.21
        draft.vat_amount = 12.12
        draft.gross_amount = 100.00
        draft.margin_in_base_currency = 0
        draft.margin_percentage = 0
        draft.lines = [
          Economic::Line.new({
            "lineNumber" => 5,
            "description" => "Frisk torsk - med rogn",
            "unit" => {"unitNumber" => 1},
            "product" => {"productNumber" => "1"},
            "quantity" => 3.0,
            "unitNetPrice" => 153.44,
            "discountPercentage" => 10,
            "unitCostPrice" => 10.2,
            "marginInBaseCurrency" => 0,
            "marginPercentage" => 0
          }),
          Economic::Line.new({
            "lineNumber" => 5,
            "description" => "Helleflynder",
            "unit" => {"unitNumber" => 1},
            "product" => {"productNumber" => "3"},
            "quantity" => 2.0,
            "unitNetPrice" => 23.00,
            "discountPercentage" => 0,
            "unitCostPrice" => 10.22,
            "marginInBaseCurrency" => 0,
            "marginPercentage" => 0
          })
        ]

        response = Economic::Invoices::DraftsRepo.save draft

        assert_equal "Torstens Torskebutik", response.recipient.name
        assert_equal "Hejrevej 1", response.recipient.address
        assert_equal "Byen", response.recipient.city
        assert_equal "1234", response.recipient.zip
        assert_equal "Danmark", response.recipient.country
        assert_equal "nummer 1", response.recipient.public_entry_number
      end
    end

    describe "destroy" do
      it "can destroy an invoice" do
        stub_get_request(endpoint: "invoices/drafts", page_or_id: "23", fixture_name: "invoice_delete", method: :delete)

        assert_equal true, Economic::Invoices::DraftsRepo.destroy(23)
      end
    end
  end
end
