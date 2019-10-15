require "test_helper"

class CustomerContactRepoTest < Minitest::Test
  describe "For customer contact" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end

    it "builds the correct endpoint" do
      model = Economic::Customer.new({"name" => "Some customer", "customerNumber" => 12})

      assert_equal "https://restapi.e-conomic.com/customers/12/contacts", Economic::CustomerContactRepo.endpoint_url(model)
    end
  end
end
