require "test_helper"

class InvoiceTest < Minitest::Test
  describe "#build_from_soap_api" do
    it "can also build references" do
      hash = {
        currency_handle: {
          code: 1,
        },
        date: Date.today,
        due_date: Date.today,
        exchange_rate: "123.12",
        handle: {
          id: 1,
        },
        margin: 0,
        margin_as_percent: 0,
        net_amount: 10,
        rounding_amount: 10,
        vat_amount: 10,
        debtor_handle: {
          id: 1,
        },
        layout_handle: {
          id: 1,
        },
        term_of_payment_handle: {
          id: 1,
        },
        other_reference: "a_reference",
      }
      Economic::Invoices::DraftsRepo.stubs(:find_lines).returns([])
      invoice = Economic::Invoice.build_from_soap_api(hash)

      assert_equal "a_reference", invoice.references.other
    end
  end
end
