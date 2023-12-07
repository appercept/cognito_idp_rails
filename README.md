# CognitoIdpRails

Simple integration of Amazon Cognito IdP (User Pools) for Rails applications.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add cognito_idp_rails

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install cognito_idp_rails

## Usage

After adding the gem to your application, run the install generator:

    $ rails generate cognito_idp_rails:install

This generator will add `cognito_idp` to your routes and install an initializer at `config/initializers/cognito_idp.rb`.

Be sure to review and edit the initializer to configure options for your Amazon Cognito User Pool configuration. You
must also provide an implementation for the `on_valid_login` function in the initializer appropriate for any actions you
want to take when a user signed in.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/appercept/cognito_idp_rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/appercept/cognito_idp_rails/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CognitoIdpRails project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/appercept/cognito_idp_rails/blob/main/CODE_OF_CONDUCT.md).
