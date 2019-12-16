require "test_helper"

class DepartmentRepoTest < Minitest::Test
  describe "for Department" do
    before do
      Economic::Session.authentication("Demo", "Demo")
    end

    describe "#all" do
      it "finds all departments" do
        stub_get_request(endpoint: "departments", fixture_name: "departments")

        departments = Economic::DepartmentRepo.all

        assert_equal 1, departments.count
        assert_kind_of Economic::Department, departments.first
        assert_equal "Department1", departments.first.name
      end
    end

    describe "#find" do
      it "finds a specific department" do
        stub_get_request(endpoint: "departments", page_or_id: 1, fixture_name: "department")

        department = Economic::DepartmentRepo.find(1)

        assert_equal 1, department.id_key
        assert_equal "Department1", department.name
      end
    end
  end
end
