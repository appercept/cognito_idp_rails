require "rails_helper"

RSpec.describe CognitoIdpRails::Routing::MapperExtensions, type: :routing do
  it "defines cognito_idp method" do
    expect(ActionDispatch::Routing::Mapper.new(ActionDispatch::Routing::RouteSet.new)).to respond_to(:cognito_idp)
  end

  before do
    Rails.application.routes.draw do
      cognito_idp
    end
    Rails.application.reload_routes!
  end

  it "adds login route" do
    expect(Rails.application.routes.recognize_path("/login")).to match(controller: "cognito_idp_rails/sessions", action: "login")
  end

  it "adds auth_login_callback route" do
    expect(Rails.application.routes.recognize_path("/auth/login_callback")).to match(controller: "cognito_idp_rails/sessions", action: "login_callback")
  end

  it "adds logout route" do
    expect(Rails.application.routes.recognize_path("/logout")).to match(controller: "cognito_idp_rails/sessions", action: "logout")
  end

  it "adds auth_logout_callback route" do
    expect(Rails.application.routes.recognize_path("/auth/logout_callback")).to match(controller: "cognito_idp_rails/sessions", action: "logout_callback")
  end
end
