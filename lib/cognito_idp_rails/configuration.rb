module CognitoIdpRails
  class Configuration
    attr_accessor :after_login_route, :after_logout_route, :domain, :client_id,
      :client_secret, :on_logout, :on_valid_login, :scope

    def initialize
      @after_login_route = "/"
      @after_logout_route = "/"
      @on_valid_login = lambda { |token, user_info, session| }
      @on_logout = lambda { |session| }
    end
  end
end
