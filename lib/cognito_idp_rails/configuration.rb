module CognitoIdpRails
  class Configuration
    attr_accessor :after_login_route, :after_logout_route, :domain, :client_id,
      :client_secret, :after_login, :before_logout, :on_login_error, :scope

    def initialize
      @after_login_route = "/"
      @after_logout_route = "/"
      @after_login = lambda { |token, user_info, request| }
      @before_logout = lambda { |request| }
      @on_login_error = lambda { |error, request| }
    end
  end
end
