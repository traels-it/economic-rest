require "test_helper"

class BaseRepoTest < Minitest::Test
  describe "tranlsate url" do
    it "returns correct _$_ substitutions" do
      urled_id = Economic::BaseRepo.id_to_url_formatted_id('P P %:<<**>>%_\\\\_//:?.#+1')
      assert_equal "P_9_P_9__3__4__0__0__2__2__1__1__3__8__7__7__8__6__6__4__10__11__12__13_1", urled_id
    end
  end
end
