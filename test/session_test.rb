require "test_helper"

class SessionTest < Minitest::Test
  describe "authentication header" do
    it "throws exception if not logged in" do
      assert_raises
    end

    it "uses private tokens if logged in" do
      Economic::Session.authentication("ybyb9a8c", "awesome_app_id")

      assert_equal "ybyb9a8c", Economic::Session.app_secret_token
      assert_equal "awesome_app_id", Economic::Session.agreement_grant_token
    end
  end
end
