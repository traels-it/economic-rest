require "active_support/concern"

module Economic
  module SoapMethods
    extend ActiveSupport::Concern

    class_methods do
      def find(id)
        result = Economic::SoapAPI.call(
          soap_method_names[:find][:method],
          message: {soap_method_names[:find][:handle] => {Id: id}}
        )

        model.build_from_soap_api(result)
      end

      def all
        result = Economic::SoapAPI.call(
          soap_method_names[:all][:method],
        )

        ids = result_array(result[soap_method_names[:all][:handle]]).map { |record|
          record[:id].to_i
        }

        find_all_records(ids)
      end

      def send(model)
        # There is a current_invoice_create_from_data_array method for bulk creation of invoices as well, but bulk
        # creation is not supported by the e-conomic REST api or any other REST api. To avoid implementing
        # functionality that will be removed once e-conomic finish the REST api, we only use the standard create end
        # point

        result = Economic::SoapAPI.call(
          soap_method_names[:send][:method], message: {
            soap_method_names[:send][:handle] => {
              Number: model.customer.customerNumber,
            },
          }
        )

        model.id_key = result[:id]

        create_lines(model) if model.lines.any?

        find(result[:id].to_i)
      end

      def find_lines(invoice_id)
        result = Economic::SoapAPI.call(
          soap_method_names[:find_lines][:method],
          message: {soap_method_names[:find_lines][:handle] => {Id: invoice_id}}
        )

        return if result.nil?

        line_ids = result_array(result[soap_method_names[:find_lines][:line_handle]]).map { |line|
          line[:number].to_i
        }

        find_all_lines(invoice_id, line_ids)
      end

      def destroy(id)
        # The SoapAPI raises an exception if the record you try to delete is missing

        result = Economic::SoapAPI.call(
          soap_method_names[:destroy][:method],
          message: {soap_method_names[:destroy][:handle] => {Id: id}}
        )

        true
      rescue Savon::SOAPFault
        false
      end

      private

      # Since the soap api returns hashes, if there is a single record, and arrays, if there are more, this method
      # wraps a response in an array, if it is not already.
      def result_array(result)
        return result if result.is_a? Array

        [result]
      end

      def create_lines(model)
        Economic::SoapAPI.call(
          soap_method_names[:create_lines][:method], message: {
            dataArray: build_line_data_array(model),
          }
        )
      end

      def find_all_lines(invoice_id, line_ids)
        result = Economic::SoapAPI.call(
          soap_method_names[:find_all_lines][:method],
          message: {soap_method_names[:find_all_lines][:handle] => line_ids_array(invoice_id, line_ids, handle: soap_method_names[:find_all_lines][:line_handle])}
        )

        result_array(result[soap_method_names[:find_all_lines][:data]]).map do |data|
          Economic::Line.build_from_soap_api(data)
        end
      end

      def find_all_records(invoice_ids)
        result = Economic::SoapAPI.call(
          soap_method_names[:find_all_records][:method],
          message: {
            entityHandles: ids_array(invoice_ids, handle: soap_method_names[:find_all_records][:handle]),
          }
        )

        result[soap_method_names[:find_all_records][:data]].map do |data|
          model.build_from_soap_api(data)
        end
      end

      def line_ids_array(order_id, line_ids, handle:)
        arr = [handle => []]

        line_ids.each do |line_id|
          arr.first[handle].push(
            {
              Id: order_id,
              Number: line_id,
            }
          )
        end

        arr
      end

      def ids_array(invoice_ids, handle:)
        arr = [handle => []]

        invoice_ids.each do |invoice_id|
          arr.first[handle].push(
            {
              Id: invoice_id,
            }
          )
        end

        arr
      end

      def build_line_data_array(order)
        arr = [soap_method_names[:create_lines][:line_data_handle] => []]

        order.lines.each do |line|
          arr.first[soap_method_names[:create_lines][:line_data_handle]].push(
            {
              :Handle => {
                Id: order.id_key,
                Number: line.line_number, # must be sent - does not have to fit with the next linenumber
              },
              :Id => order.id_key,
              :Number => line.line_number, # must be sent - does not have to fit with the next linenumber
              soap_method_names[:create_lines][:model_handle] => {
                Id: order.id_key,
              },
              :Description => line.description,
              :DeliveryDate => line.delivery.delivery_date,
              :UnitHandle => {Number: line.unit.unit_number},
              :ProductHandle => {Number: line.product.product_number},
              :Quantity => line.quantity,
              :UnitNetPrice => line.unit_net_price,
              :DiscountAsPercent => line.discount_percentage,
              :UnitCostPrice => line.unit_cost_price,
              :TotalNetAmount => line.total_net_amount, # TODO: Should this not be sent?
              :TotalMargin => line.margin_in_base_currency,
              :MarginAsPercent => line.margin_percentage,
            }
          )
        end

        arr
      end
    end
  end
end
