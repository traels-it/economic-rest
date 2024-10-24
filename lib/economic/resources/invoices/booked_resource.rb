module Economic
  module Resources
    module Invoices
      class BookedResource < Economic::Resource
        def create(model, send_by: nil)
          hash = model.to_h
          hash[:sendBy] = send_by if send_by.to_s == "ean"
          super(hash)
        end

        private

        def endpoint
          resource_name.underscore.dasherize
        end
      end
    end
  end
end
