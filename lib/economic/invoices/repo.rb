module Economic
  module Invoices
    class Repo < Economic::BaseRepo
      def self.all
        invoices = super
        invoices.each do |invoice|
          invoice.remove_instance_variable("@lines")
          class << invoice
            define_method(:lines) { raise NoMethodError }
          end
        end
        invoices
      end
    end
  end
end
