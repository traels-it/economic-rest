module Economic
  class Configuration
    class << self
      attr_accessor :app_secret_token, :agreement_grant_token
    end
  end
end
