require_relative "lib/cognito_idp_rails/version"

Gem::Specification.new do |spec|
  spec.name = "cognito_idp_rails"
  spec.version = CognitoIdpRails::VERSION
  spec.authors = ["Richard Hatherall"]
  spec.email = ["richard@appercept.com"]
  spec.homepage = "https://github.com/appercept/cognito_idp_rails"
  spec.summary = "Simple Rails integration for Amazon Cognito IdP (User Pools)"
  spec.description = "Simple Rails integration for authentication through Amazon Cognito IdP (User Pools)"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "cognito_idp", ">= 0.1.1"
  spec.add_dependency "rails", ">= 7.0.0"
end
