require "test_helper"

class DepartmentalDistributionRepoTest < Minitest::Test
  describe "for DepartmentalDistribution" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end

    describe "#all" do
      it "finds all departmental distributions" do
        stub_get_request(endpoint: "departmental-distributions", fixture_name: "departmental_distributions")

        distributions = Economic::DepartmentalDistributionRepo.all

        assert_equal 1, distributions.count
        assert_kind_of Economic::DepartmentalDistribution, distributions.first
        assert_equal "Department1", distributions.first.name
      end

      it "can find only those departmental distributions that distribute the entire sum to a single department" do
        stub_get_request(endpoint: "departmental-distributions/departments", fixture_name: "departmental_distributions_single_department")

        distributions = Economic::DepartmentalDistributionRepo.all(distribution: :single_department)

        assert_equal 1, distributions.count
        assert_kind_of Economic::DepartmentalDistribution, distributions.first
        assert_equal "Department1", distributions.first.name
      end

      it "can find only those departmental distributions that distribute the sum to multiple departments" do
        stub_get_request(endpoint: "departmental-distributions/distributions", fixture_name: "departmental_distributions_multiple_departments")

        distributions = Economic::DepartmentalDistributionRepo.all(distribution: :multiple_departments)

        assert_equal 0, distributions.count
      end
    end

    describe "#find" do
      it "can find a specific departmental distribution that distributes all to a single department" do
        stub_get_request(endpoint: "departmental-distributions/departments", page_or_id: 1, fixture_name: "departmental_distribution_single_department")

        distribution = Economic::DepartmentalDistributionRepo.find(1, distribution: :single_department)

        assert_equal "Department1", distribution.name
        assert_equal 1, distribution.id_key
        assert_kind_of Economic::DepartmentalDistribution, distribution
      end

      it "can find a specific departmental distribution that distributes between multiple departments" do
        skip "There are no distrubtions of this type in the test api"
      end
    end
  end
end
