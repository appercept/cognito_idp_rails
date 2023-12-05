require "cognito_idp"

module CognitoIdpRails
  class SessionsController < ApplicationController
    before_action :verify_state, only: [:login_callback]

    def login
      redirect_to authorization_url, allow_other_host: true
    end

    def login_callback
      client.get_token(grant_type: :authorization_code, code: params[:code], redirect_uri: auth_login_callback_url) do |token|
        client.get_user_info(token) do |user_info|
          reset_session
          configuration.on_valid_login.call(token, user_info, session)
          redirect_to configuration.after_login_route, notice: "You have been successfully logged in."
          return
        end
      end
      redirect_to configuration.after_login_route, notice: "Login failed."
    end

    def logout
      redirect_to client.logout_uri(logout_uri: auth_logout_callback_url), allow_other_host: true
    end

    def logout_callback
      configuration.on_logout.call(session)
      reset_session
      redirect_to configuration.after_logout_route, notice: "You have been successfully logged out."
    end

    private

    def authorization_url
      client.authorization_uri(redirect_uri: auth_login_callback_url, scope: scope, state: login_state)
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

    def login_state
      session[:login_state] ||= SecureRandom.urlsafe_base64
    end

    def verify_state
      return if params[:state] == login_state

      redirect_to configuration.after_login_route, notice: "Login failed."
    end
  end
end
