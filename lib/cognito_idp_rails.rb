require "cognito_idp_rails/engine"
require "cognito_idp_rails/version"
require "cognito_idp"

module CognitoIdpRails
  autoload :Configuration, "cognito_idp_rails/configuration"

  module Routing
    autoload :MapperExtensions, "cognito_idp_rails/routing/mapper_extensions"
  end

  class << self
    def client
      @client ||= CognitoIdp::Client.new(
        client_id: configuration.client_id,
        client_secret: configuration.client_secret,
        domain: configuration.domain
      )
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
