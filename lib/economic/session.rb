module Economic
  # The Economic::Session contains details and behaviors for a current
  # connection to the API endpoint.
  class Session
    def self.authentication(private_app_id, access_id)
      @private_app_id = private_app_id
      @access_id = access_id
    end

    def self.app_secret_token
      raise ArgumentError, "Authentication tokens not set, Call Session.authentication" if @private_app_id.nil?

      @private_app_id
    end

    def self.agreement_grant_token
      raise ArgumentError, "Authentication tokens not set, Call Session.authentication" if @access_id.nil?

      @access_id
    end
  end
end
