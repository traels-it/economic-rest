module Economic
  module Models
    module Customers
      class Contact < Economic::Model
        field :id, as: :customerContactNumber
        field :deleted
        field :e_invoice_id
        field :email
        field :email_notifications
        field :name
        field :notes
        field :phone
        field :sort_key

        relation :customer
      end
    end
  end
end
