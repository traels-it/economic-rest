require 'economic/rest/version'
require 'rest-client'

require 'economic/base_repo'
require 'economic/base'
require 'economic/customer_repo'
require 'economic/customer'
require 'economic/product_repo'
require 'economic/product'

require 'economic/orders/repo'
require 'economic/order'
require 'economic/orders/archived_repo'
require 'economic/orders/drafts_repo'
require 'economic/orders/sent_repo'

require 'economic/journal_repo'
require 'economic/journal'

require 'economic/accounting_year'
require 'economic/voucher'

module Economic
  class Demo
    def self.hello
      RestClient.get('https://restapi.e-conomic.com/',
                     'X-AppSecretToken': 'Demo',
                     'X-AgreementGrantToken': 'Demo',
                     'Content-Type': 'application/json')
    end
  end
end
