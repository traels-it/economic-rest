module Economic
  # The Economic::Session contains details and behaviors for a current
  # connection to the API endpoint.
  class Session
    class << self
      def authentication(private_app_id, access_id)
        @private_app_id = private_app_id
        @access_id = access_id
      end
      alias authenticate authentication

      def app_secret_token
        raise ArgumentError, "Authentication tokens not set, Call Session.authentication" if @private_app_id.nil?

        @private_app_id
      end

      def agreement_grant_token
        raise ArgumentError, "Authentication tokens not set, Call Session.authentication" if @access_id.nil?

        @access_id
      end
    end
  end
end
