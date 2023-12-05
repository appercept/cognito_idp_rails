require "rails/generators"

module CognitoIdpRails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Add an initializer and routes for Cognito IdP to your app"
      source_root File.expand_path("templates", __dir__)

      def copy_initializer
        template "cognito_idp_rails_initializer.rb.tt", "config/initializers/cognito_idp.rb"
      end

      def add_routes
        route "cognito_idp"
      end
    end
  end
end
