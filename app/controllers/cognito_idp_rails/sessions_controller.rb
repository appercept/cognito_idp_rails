require "cognito_idp"

module CognitoIdpRails
  class SessionsController < ApplicationController
    before_action :verify_state, only: [:login_callback]

    def login
      redirect_to authorization_url, allow_other_host: true
    end

    def login_callback
      verifier = session.delete(:code_verifier)
      session.delete(:login_state)
      token = client.get_token(grant_type: :authorization_code, code: params[:code], redirect_uri: auth_login_callback_url, code_verifier: verifier)
      user_info = client.get_user_info(token)
      reset_session
      configuration.after_login.call(token, user_info, request)
      redirect_to configuration.after_login_route, notice: "You have been successfully logged in."
    rescue CognitoIdp::Error => e
      configuration.on_login_error.call(e, request)
      redirect_to configuration.after_login_route, notice: "Login failed."
    end

    def logout
      redirect_to client.logout_uri(logout_uri: auth_logout_callback_url), allow_other_host: true
    end

    def logout_callback
      configuration.before_logout.call(request)
      reset_session
      redirect_to configuration.after_logout_route, notice: "You have been successfully logged out."
    end

    private

    def authorization_url
      client.authorization_uri(
        redirect_uri: auth_login_callback_url,
        scope: scope,
        state: login_state,
        code_challenge: code_challenge,
        code_challenge_method: "S256"
      )
    end

    def client
      CognitoIdpRails.client
    end

    def configuration
      CognitoIdpRails.configuration
    end

    def scope
      configuration.scope
    end

    def code_verifier
      session[:code_verifier] ||= SecureRandom.urlsafe_base64(32)
    end

    def code_challenge
      Base64.urlsafe_encode64(Digest::SHA256.digest(code_verifier), padding: false)
    end

    def login_state
      session[:login_state] ||= SecureRandom.urlsafe_base64
    end

    def verify_state
      return if params[:state] == login_state

      redirect_to configuration.after_login_route, notice: "Login failed."
    end
  end
end
