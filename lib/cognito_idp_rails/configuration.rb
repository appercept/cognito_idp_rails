module CognitoIdpRails
  class Configuration
    attr_accessor :after_login_route, :after_logout_route, :domain, :client_id,
      :client_secret, :after_login, :before_logout, :scope

    def initialize
      @after_login_route = "/"
      @after_logout_route = "/"
      @after_login = lambda { |token, user_info, request| }
      @before_logout = lambda { |request| }
    end
  end
end
