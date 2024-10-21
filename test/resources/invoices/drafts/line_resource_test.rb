require "test_helper"

module Resources
  class LineResourceTest < Minitest::Test
    describe "Economic::Resources::Invoices::Drafts::LineResource" do
      before { set_credentials }

      describe "#create" do
        it "adds lines to an existing draft invoice" do
          stub_request(:post, "https://restapi.e-conomic.com/invoices/drafts/139/lines")
            .with(body: "{\"lines\":[{\"lineNumber\":1,\"description\":\"Line added after invoice creation\",\"sortKey\":1,\"quantity\":1.0,\"unitNetPrice\":10.0,\"discountPercentage\":0.0,\"unitCostPrice\":46.93,\"marginInBaseCurrency\":-46.93,\"marginPercentage\":0.0,\"totalNetAmount\":10.0,\"product\":{\"productNumber\":\"51\"},\"unit\":{\"unitNumber\":2,\"name\":\"Tim\"}}]}")
            .to_return(status: 200, body: {lines: [{lineNumber: 4}]}.to_json, headers: {})

          draft_invoice = Economic::Models::Invoices::Draft.new(id: 139)
          unit = Economic::Models::Unit.new(id: 2, name: "Tim")
          product = Economic::Models::Product.new(id: "51")
          lines = [
            Economic::Models::Line.new(
              id: 1,
              description: "Line added after invoice creation",
              sort_key: 1,
              quantity: 1.00,
              unit_net_price: 10.00,
              discount_percentage: 0.00,
              unit_cost_price: 46.93,
              total_net_amount: 10.00,
              margin_in_base_currency: -46.93,
              margin_percentage: 0.0,
              unit:,
              product:
            )
          ]

          Economic::Resources::Invoices::Drafts::LineResource.new.create(draft_invoice, lines)
        end
      end
    end
  end
end
