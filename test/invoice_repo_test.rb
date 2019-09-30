require "test_helper"

class InvoiceRepoTest < Minitest::Test
  describe "For invoice" do
    before do
      Economic::Session.authentication("Demo", "Demo")
      stub_soap_authentication
    end

    describe "find" do
      before do
        stub_soap_get_request(soap_action: "CurrentInvoice_GetData")
        stub_soap_get_request(soap_action: "CurrentInvoice_GetLines")
        stub_soap_get_request(soap_action: "CurrentInvoiceLine_GetDataArray")
      end

      it "can find draft by id" do
        draft = Economic::Invoices::DraftsRepo.find(8)

        assert_equal "DKK", draft.to_h["currency"]
        assert_equal "DKK", draft.currency
        assert_equal 18, draft.layout.layout_number
        assert_kind_of Economic::Invoice, draft
      end

      it "can find draft with lines" do
        draft = Economic::Invoices::DraftsRepo.find(8)

        assert_equal 3, draft.lines.size
        assert_equal 2.00, draft.lines[2].quantity
        assert_kind_of Economic::Line, draft.lines.first
        assert_kind_of Economic::Invoice, draft
      end
    end

    describe "all" do
      before do
        stub_soap_get_request(soap_action: "CurrentInvoice_GetAll")
        stub_soap_get_request(soap_action: "CurrentInvoice_GetDataArray")
        stub_soap_get_request(soap_action: "CurrentInvoice_GetLines")
        stub_soap_get_request(soap_action: "CurrentInvoiceLine_GetDataArray")
      end

      it "can find all drafts" do
        drafts = Economic::Invoices::DraftsRepo.all

        assert_equal 2, drafts.size
        assert_kind_of Economic::Invoice, drafts.first
      end
    end

    describe "send" do
      before do
        stub_soap_get_request(soap_action: "CurrentInvoice_Create")
        stub_soap_get_request(soap_action: "CurrentInvoiceLine_CreateFromDataArray")
        stub_soap_get_request(soap_action: "CurrentInvoice_GetData")
        stub_soap_get_request(soap_action: "CurrentInvoice_GetLines")
        stub_soap_get_request(soap_action: "CurrentInvoiceLine_GetDataArray")
      end

      it "can post" do
        draft = Economic::Invoice.new({})
        draft.currency = "DKK"
        draft.customer.customer_number = 641
        draft.date = Date.today
        draft.due_date = Date.today.next_day
        draft.layout.layout_number = 19
        draft.recipient.name = "Torstens Torskebutik"
        draft.recipient.vat_zone.vat_zone_number = 1
        draft.payment_terms.payment_terms_number = 1
        draft.lines = [
          Economic::Line.new({
            "lineNumber" => 5,
            "description" => "Frisk torsk - med rogn",
            "unit" => {"unitNumber" => 1},
            "product" => {"productNumber" => "MED-1000"},
            "quantity" => 3.0,
            "unitNetPrice" => 153.44,
            "discountPercentage" => 10,
            "unitCostPrice" => 10.2,
            "marginInBaseCurrency" => 0,
            "marginPercentage" => 0,
          }),
          Economic::Line.new({
            "lineNumber" => 5,
            "description" => "Helleflynder",
            "unit" => {"unitNumber" => 1},
            "product" => {"productNumber" => "Anno-1004"},
            "quantity" => 2.0,
            "unitNetPrice" => 23.00,
            "discountPercentage" => 0,
            "unitCostPrice" => 10.22,
            "marginInBaseCurrency" => 0,
            "marginPercentage" => 0,
          }),
        ]

        response = Economic::Invoices::DraftsRepo.send draft
        assert_kind_of Economic::Invoice, response
      end
    end

    describe "destroy" do
      before do
        stub_soap_get_request(soap_action: "CurrentInvoice_Delete")
      end

      it "can destroy an invoice" do
        assert_equal true, Economic::Invoices::DraftsRepo.destroy(12)
      end
    end
  end
end
