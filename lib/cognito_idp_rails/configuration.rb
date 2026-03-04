module CognitoIdpRails
  class Configuration
    attr_accessor :after_login_route, :after_logout_route, :domain, :client_id,
      :client_secret, :after_login, :before_logout, :on_login_error, :scope

    REQUIRED_ATTRIBUTES = %i[domain client_id client_secret].freeze

    def initialize
      @after_login_route = "/"
      @after_logout_route = "/"
      @after_login = lambda { |token, user_info, request| }
      @before_logout = lambda { |request| }
      @on_login_error = lambda { |error, request| }
      @scope = "openid"
    end

    def validate!
      missing = REQUIRED_ATTRIBUTES.select { |attr| public_send(attr).nil? }
      return if missing.empty?

      raise ConfigurationError, "Missing required configuration: #{missing.join(", ")}"
    end
  end
end
