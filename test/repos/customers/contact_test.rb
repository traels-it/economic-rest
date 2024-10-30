require "test_helper"

module Repos
  module Customers
    class ContactTest < Minitest::Test
      describe Economic::Repos::Customers::Contact do
        before { set_credentials }

        describe "#all" do
          it "returns all customer_contacts" do
            stub_get_request(endpoint: "customers/1/contacts", fixture_name: "customer_contacts")

            customer_contacts = Economic::Repos::Customers::Contact.new(Economic::Models::Customer.new(id: 1)).all
            customer_contact = customer_contacts.first

            assert_kind_of Economic::Models::Customers::Contact, customer_contact
            assert_equal 1, customer_contact.id
            assert_equal "Frasier Crane", customer_contact.name
            assert_equal 3, customer_contacts.length
          end
        end
      end
    end
  end
end
