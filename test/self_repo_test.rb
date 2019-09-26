require "test_helper"

class SelfRepoTest < Minitest::Test
  describe "Self" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end

    it "gets self" do
      stub_get_request(endpoint: "self", fixture_name: "self", paged: false)

      _self = Economic::SelfRepo.self
      assert_equal "The Demo Company", _self.company.name
      assert_kind_of Economic::Company, _self.company
      assert_equal "John Doe", _self.user.name
    end
  end
end
