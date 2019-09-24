require "test_helper"

class JournalRepoTest < Minitest::Test
  describe "For Journal" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end

    it "can get all journals" do
      stub_get_request(endpoint: "journals-experimental", fixture_name: "journals_0")

      journals = Economic::JournalRepo.all

      assert_equal 3, journals[2].to_h["journalNumber"]
      assert_kind_of Economic::Journal, journals[0]
    end

    it "can find a specific journal by number" do
      stub_get_request(endpoint: "journals-experimental", page_or_id: 2, fixture_name: "journal")

      journal = Economic::JournalRepo.find(2)

      assert_equal "Lønninger", journal.to_h["name"]
      assert_kind_of Economic::Journal, journal
    end

    it "returns json data based on changes to the model" do
      # should be moved, this is basicaly a model test
      stub_get_request(endpoint: "journals-experimental", page_or_id: 2, fixture_name: "journal")

      journal = Economic::JournalRepo.find(2)

      assert journal.to_h.inspect.include? "Lønninger"
    end
  end
end
