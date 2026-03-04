# CognitoIdpRails [![Ruby](https://github.com/appercept/cognito_idp_rails/actions/workflows/main.yml/badge.svg)](https://github.com/appercept/cognito_idp_rails/actions/workflows/main.yml)

Simple integration of Amazon Cognito IdP (User Pools) for Rails applications. Provides OAuth + PKCE authentication with sensible defaults and minimal configuration.

## Requirements

- Ruby >= 3.2.0
- Rails >= 7.0.0
- [cognito_idp](https://github.com/appercept/cognito_idp) ~> 1.0 (installed automatically)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add cognito_idp_rails

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install cognito_idp_rails

## Setup

Run the install generator:

    $ rails generate cognito_idp_rails:install

This will:

1. Add a `cognito_idp` route entry to `config/routes.rb`
2. Create an initializer at `config/initializers/cognito_idp.rb`

Review and edit the initializer to match your Amazon Cognito User Pool configuration.

## Configuration

```ruby
CognitoIdpRails.configure do |config|
  config.domain = ENV["COGNITO_DOMAIN"]
  config.client_id = ENV["COGNITO_CLIENT_ID"]
  config.client_secret = ENV["COGNITO_CLIENT_SECRET"]

  config.scope = "openid"          # OAuth scope(s)
  config.after_login_route = "/"   # Redirect after login
  config.after_logout_route = "/"  # Redirect after logout

  config.after_login = lambda do |token, user_info, request|
    user = User.where(identifier: user_info.sub).first_or_create do |u|
      u.email = user_info.email
    end
    request.session[:user_id] = user.id
  end

  config.before_logout = lambda do |request|
    # Runs before the session is reset on logout
  end

  config.on_login_error = lambda do |error, request|
    # Runs when token exchange or user info retrieval fails
    Rails.logger.error("Login failed: #{error.message}")
  end
end
```

### Options

| Option | Required | Default | Description |
|---|---|---|---|
| `domain` | Yes | — | Your Cognito User Pool domain (e.g. `your-app.auth.us-east-1.amazoncognito.com`) |
| `client_id` | Yes | — | The app client ID from your Cognito User Pool |
| `client_secret` | Yes | — | The app client secret from your Cognito User Pool |
| `scope` | No | `"openid"` | OAuth scope(s) to request |
| `after_login_route` | No | `"/"` | Path to redirect to after login |
| `after_logout_route` | No | `"/"` | Path to redirect to after logout |
| `after_login` | No | no-op | `lambda { \|token, user_info, request\| }` — called after successful authentication |
| `before_logout` | No | no-op | `lambda { \|request\| }` — called before session reset on logout |
| `on_login_error` | No | no-op | `lambda { \|error, request\| }` — called when login fails (receives a `CognitoIdp::Error`) |

## Routes

The `cognito_idp` route helper adds four routes:

| Route | Controller Action | Purpose |
|---|---|---|
| `GET /login` | `sessions#login` | Redirects to Cognito authorization endpoint |
| `GET /auth/login_callback` | `sessions#login_callback` | Handles the OAuth callback from Cognito |
| `GET /logout` | `sessions#logout` | Redirects to Cognito logout endpoint |
| `GET /auth/logout_callback` | `sessions#logout_callback` | Handles the logout callback from Cognito |

## How it works

CognitoIdpRails implements the OAuth 2.0 Authorization Code flow with PKCE (Proof Key for Code Exchange):

1. User visits `/login`
2. A PKCE code verifier/challenge pair and CSRF state token are generated and stored in the session
3. User is redirected to your Cognito User Pool's authorization endpoint
4. After authenticating with Cognito, the user is redirected back to `/auth/login_callback`
5. The CSRF state is verified, and the authorization code is exchanged for tokens using the PKCE code verifier
6. User info is fetched from Cognito using the access token
7. The session is reset, the `after_login` callback is called, and the user is redirected to `after_login_route`

On logout, the user is redirected to Cognito's logout endpoint, then back to `/auth/logout_callback` where `before_logout` is called and the session is reset.

## Customizing flash messages (i18n)

Flash messages are set via i18n. Override them in your application's locale files:

```yaml
en:
  cognito_idp_rails:
    sessions:
      login_success: "You have been successfully logged in."
      login_failed: "Login failed."
      logout_success: "You have been successfully logged out."
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/appercept/cognito_idp_rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/appercept/cognito_idp_rails/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CognitoIdpRails project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/appercept/cognito_idp_rails/blob/main/CODE_OF_CONDUCT.md).
