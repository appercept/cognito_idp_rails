module CognitoIdpRails
  class Engine < ::Rails::Engine
    initializer "cognito_idp_rails.add_routing_paths" do |app|
      ActionDispatch::Routing::Mapper.send(:include, CognitoIdpRails::Routing::MapperExtensions)
    end

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
