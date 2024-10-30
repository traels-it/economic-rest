require "test_helper"

class PaginationTest < Minitest::Test
  describe ".from_json" do
    it "builds a pagination object" do
      json = File.read(json_fixture("pagination"))

      pagination = Economic::Response::Pagination.from_json(json)

      assert_instance_of Economic::Response::Pagination, pagination
      assert_equal 1000, pagination.max_page_size_allowed
      assert_equal 0, pagination.skip_pages
      assert_equal 1000, pagination.page_size
      assert_equal 3684, pagination.results
      assert_equal 3684, pagination.results_without_filter
      assert_equal "https://restapi.e-conomic.com/customers?skippages=0&pagesize=1000", pagination.first_page
      assert_equal "https://restapi.e-conomic.com/customers?skippages=1&pagesize=1000", pagination.next_page
      assert_equal "https://restapi.e-conomic.com/customers?skippages=3&pagesize=1000", pagination.last_page
    end
  end
end
