require "rails_helper"

RSpec.describe "Sessions", type: :request do
  before do
    allow(CognitoIdpRails).to receive(:client).and_return(client)
    allow(configuration).to receive(:on_valid_login).and_return(on_valid_login)
    allow(on_valid_login).to receive(:call)
    allow(configuration).to receive(:on_logout).and_return(on_logout)
    allow(on_logout).to receive(:call)
  end

  let(:configuration) { CognitoIdpRails.configuration }
  let(:client) { CognitoIdp::Client.new(client_id: client_id, client_secret: client_secret, domain: domain) }
  let(:client_id) { "client-1" }
  let(:client_secret) { "SECRET" }
  let(:domain) { "auth.example.com" }
  let(:redirect_uri) { "http://www.example.com/auth/login_callback" }
  let(:on_valid_login) do
    lambda { |token, user_info, session| }
  end
  let(:on_logout) do
    lambda { |session| }
  end

  describe "GET /login" do
    let(:response_location) { URI(response.headers["location"]) }
    let(:redirect_params) { URI.decode_www_form(response_location.query) }

    it "redirects to the authorization server" do
      get "/login"

      expect(response).to redirect_to(%r{\Ahttps://auth.example.com/oauth2/authorize})
    end

    it "redirects with a client_id" do
      get "/login"

      expect(redirect_params).to include(["client_id", client_id])
    end

    it "redirects with a redirect_uri" do
      get "/login"

      expect(redirect_params).to include(["redirect_uri", redirect_uri])
    end

    it "redirects with a response_type" do
      get "/login"

      expect(redirect_params).to include(["response_type", "code"])
    end

    it "redirects with a state" do
      get "/login"

      expect(redirect_params).to include(["state", String])
    end

    it "remembers the login_state" do
      get "/login"

      expect(session[:login_state]).to be_present
    end
  end

  describe "GET /auth/login_callback" do
    let(:path) { "/auth/login_callback?state=#{state}&code=#{code}" }
    let(:state) do
      get "/login"
      session[:login_state]
    end
    let(:code) { "CODE" }

    shared_examples "successful login" do
      it "redirects to the after_login_route" do
        get path

        expect(response).to redirect_to(configuration.after_login_route)
      end

      it "presents a success notice" do
        get path

        expect(flash[:notice]).to eq("You have been successfully logged in.")
      end
    end

    shared_examples "unsuccessful login" do
      it "redirects to the after_login_route" do
        state

        get path

        expect(response).to redirect_to(configuration.after_login_route)
      end

      it "presents a failure notice" do
        state

        get path

        expect(flash[:notice]).to eq("Login failed.")
      end
    end

    context "when valid params are returned" do
      let(:valid_token) { CognitoIdp::Token.new(access_token: access_token) }
      let(:access_token) { "access-token" }
      let(:user_info) { CognitoIdp::UserInfo.new(user_info_params) }
      let(:user_info_params) do
        {sub: "SUB"}
      end

      before do
        allow(client).to receive(:get_token)
          .with(grant_type: :authorization_code, code: code, redirect_uri: redirect_uri)
          .and_yield(valid_token)
        allow(client).to receive(:get_user_info).with(valid_token).and_yield(user_info)
      end

      it "requests a token" do
        get path

        expect(client).to have_received(:get_token)
          .with(grant_type: :authorization_code, code: code, redirect_uri: redirect_uri)
      end

      context "when a token is received" do
        it "requests user_info" do
          get path

          expect(client).to have_received(:get_user_info).with(valid_token)
        end

        context "when user_info is received" do
          include_examples "successful login"

          it "resets the session" do
            state
            original_session_id = session[:session_id]

            get path

            expect(session[:session_id]).not_to eq(original_session_id)
          end

          it "calls back to on_valid_login" do
            get path

            expect(on_valid_login).to have_received(:call).with(valid_token, user_info, ActionDispatch::Request::Session)
          end
        end

        context "when user_info is not received" do
          before do
            allow(client).to receive(:get_token)
              .with(grant_type: :authorization_code, code: code, redirect_uri: redirect_uri)
              .and_yield(valid_token)
            allow(client).to receive(:get_user_info).with(valid_token).and_return(nil)
          end

          include_examples "unsuccessful login"

          it "does not call back to on_valid_login" do
            expect(on_valid_login).not_to have_received(:call)
          end
        end
      end

      context "when a token is not received" do
        before do
          allow(client).to receive(:get_token)
            .with(grant_type: :authorization_code, code: code, redirect_uri: redirect_uri)
            .and_return(nil)
        end

        include_examples "unsuccessful login"

        it "does not request user_info" do
          expect(client).not_to have_received(:get_user_info).with(valid_token)
        end

        it "does not call back to on_valid_login" do
          expect(on_valid_login).not_to have_received(:call)
        end
      end
    end

    context "when a valid state is not returned" do
      let(:path) { "/auth/login_callback?state=INVALID" }

      include_examples "unsuccessful login"
    end

    context "when state is not returned" do
      let(:path) { "/auth/login_callback" }

      include_examples "unsuccessful login"
    end
  end

  describe "GET /logout" do
    let(:response_location) { URI(response.headers["location"]) }
    let(:redirect_params) { URI.decode_www_form(response_location.query) }

    it "redirects to the authorization server" do
      get "/logout"

      expect(response).to redirect_to(%r{\Ahttps://auth.example.com/logout})
    end

    it "redirects with a logout_uri" do
      get "/logout"

      expect(redirect_params).to include(["logout_uri", "http://www.example.com/auth/logout_callback"])
    end
  end

  describe "GET /auth/logout_callback" do
    it "calls back to on_valid_login" do
      get "/auth/logout_callback"

      expect(on_logout).to have_received(:call).with(ActionDispatch::Request::Session)
    end

    it "redirects to the after_logout_route" do
      get "/auth/logout_callback"

      expect(response).to redirect_to(configuration.after_logout_route)
    end

    it "presents a notice" do
      get "/auth/logout_callback"

      expect(flash[:notice]).to eq("You have been successfully logged out.")
    end

    it "resets the session" do
      get "/login"
      original_session_id = session[:session_id]

      get "/auth/logout_callback"

      expect(session[:session_id]).not_to eq(original_session_id)
    end
  end
end
