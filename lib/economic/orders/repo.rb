module Economic
  module Orders
    class Repo < Economic::BaseRepo
      def self.all
        orders = super
        orders.each do |order|
          order.remove_instance_variable("@lines")
          class << order
            define_method(:lines) { raise NoMethodError }
          end
        end
        orders
      end
    end
  end
end
