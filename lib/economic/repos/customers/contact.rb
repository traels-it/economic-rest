module Economic
  module Repos
    module Customers
      class Contact < Economic::Repo
        def initialize(parent, credentials: Economic::Credentials.fetch!)
          @parent = parent
          super(credentials:)
        end

        private

        attr_reader :parent

        def endpoint
          fragments = resource_name.pluralize.underscore.dasherize.split("/")
          fragments.insert(1, "/#{parent.id}/").join
        end
      end
    end
  end
end
