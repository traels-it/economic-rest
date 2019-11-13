require "economic/rest/version"

require "rest-client"
require "savon"
require "active_support/inflector"

require "economic/base_repo"
require "economic/nested_base_repo"
require "economic/base"
require "economic/soap_api"
require "economic/concerns/soap_methods"

require "economic/attention"
require "economic/currency"
require "economic/vat_zone"
require "economic/vat_zone_repo"
require "economic/vat_type"
require "economic/vat_type_repo"
require "economic/inventory"
require "economic/customer_group"
require "economic/product_group"

require "economic/pricing"
require "economic/delivery"
require "economic/layout"
require "economic/layout_repo"
require "economic/notes"
require "economic/payment_terms"
require "economic/payment_terms_repo"
require "economic/pdf"
require "economic/project"
require "economic/recipient"
require "economic/references"

require "economic/customer_repo"
require "economic/customer"
require "economic/customer_group_repo"
require "economic/customer_contact"
require "economic/customer_contact_repo"
require "economic/product_repo"
require "economic/product"
require "economic/pricing_repo"

require "economic/orders/repo"
require "economic/order"
require "economic/orders/archived_repo"
require "economic/orders/drafts_repo"
require "economic/orders/sent_repo"
require "economic/product_group_repo"

require "economic/invoices/repo"
require "economic/invoice"
require "economic/invoices/drafts_repo"
require "economic/invoices/booked_repo"
require "economic/invoices/not_due_repo"
require "economic/invoices/overdue_repo"
require "economic/invoices/paid_repo"
require "economic/invoices/sent_repo"
require "economic/invoices/unpaid_repo"

require "economic/journal_repo"
require "economic/journal"
require "economic/journal_voucher_repo"
require "economic/voucher"

require "economic/accounting_year"
require "economic/accounting_year_repo"

require "economic/unit"
require "economic/unit_repo"

require "economic/user"

require "economic/company"
require "economic/self"
require "economic/self_repo"
require "economic/line"

require "economic/sales_person"
require "economic/vendor_reference"

require "economic/supplier"
require "economic/supplier_group"
require "economic/supplier_repo"
require "economic/supplier_contact"
require "economic/cost_account"
require "economic/remittance_advice"

require "economic/payment_type"
require "economic/payment_type_repo"

module Economic
  class Demo
    def self.hello
      RestClient.get("https://restapi.e-conomic.com/",
        'X-AppSecretToken': "Demo",
        'X-AgreementGrantToken': "Demo",
        'Content-Type': "application/json")
    end
  end
end
