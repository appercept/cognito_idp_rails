module CognitoIdpRails
  module Routing
    module MapperExtensions
      def cognito_idp
        get("/login", to: "cognito_idp_rails/sessions#login")
        get("/auth/login_callback", to: "cognito_idp_rails/sessions#login_callback")
        get("/logout", to: "cognito_idp_rails/sessions#logout")
        get("/auth/logout_callback", to: "cognito_idp_rails/sessions#logout_callback")
      end
    end
  end
end
