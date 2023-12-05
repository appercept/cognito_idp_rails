require "rails_helper"

RSpec.describe "Cognito IdP sessions routes", type: :routing do
  it { expect(get("/login")).to route_to("cognito_idp_rails/sessions#login") }
  it { expect(get("/auth/login_callback")).to route_to("cognito_idp_rails/sessions#login_callback") }
  it { expect(get("/logout")).to route_to("cognito_idp_rails/sessions#logout") }
  it { expect(get("/auth/logout_callback")).to route_to("cognito_idp_rails/sessions#logout_callback") }
end
