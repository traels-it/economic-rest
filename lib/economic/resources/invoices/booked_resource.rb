module Economic
  module Resources
    module Invoices
      class BookedResource < Economic::Resource
        private

        def endpoint
          resource_name.underscore.dasherize
        end
      end
    end
  end
end
