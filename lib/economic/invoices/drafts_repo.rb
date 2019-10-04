module Economic
  module Invoices
    class DraftsRepo < Economic::Invoices::Repo
      include Economic::SoapMethods

      class << self
        def soap_method_names
          {
            find: {method: :current_invoice_get_data, handle: :entityHandle},
            all: {method: :current_invoice_get_all, handle: :current_invoice_handle},
            send: {method: :current_invoice_create_from_data},
            find_lines: {
              method: :current_invoice_get_lines,
              handle: :currentInvoiceHandle,
              line_handle: :current_invoice_line_handle,
            },
            create_lines: {
              method: :current_invoice_line_create_from_data_array,
              line_data_handle: :CurrentInvoiceLineData,
              model_handle: :InvoiceHandle,
            },
            find_all_lines: {
              method: :current_invoice_line_get_data_array,
              handle: :entityHandles,
              data: :current_invoice_line_data,
              line_handle: :CurrentInvoiceLineHandle,
            },
            find_all_records: {
              method: :current_invoice_get_data_array,
              handle: :CurrentInvoiceHandle,
              data: :current_invoice_data,
            },
            destroy: {
              method: :current_invoice_delete,
              handle: :currentInvoiceHandle,
            },
          }
        end
      end
    end
  end
end
