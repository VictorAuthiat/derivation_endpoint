# DerivationEndpoint

[![Gem Version](https://badge.fury.io/rb/derivation_endpoint.svg)](https://badge.fury.io/rb/derivation_endpoint)
[![Build Status](https://github.com/VictorAuthiat/derivation_endpoint/actions/workflows/ci.yml/badge.svg)](https://github.com/VictorAuthiat/derivation_endpoint/actions/workflows/ci.yml)
[![Code Climate](https://codeclimate.com/github/VictorAuthiat/derivation_endpoint/badges/gpa.svg)](https://codeclimate.com/github/VictorAuthiat/derivation_endpoint)
[![Test Coverage](https://codeclimate.com/github/VictorAuthiat/derivation_endpoint/badges/coverage.svg)](https://codeclimate.com/github/VictorAuthiat/derivation_endpoint/coverage)
[![Issue Count](https://codeclimate.com/github/VictorAuthiat/derivation_endpoint/badges/issue_count.svg)](https://codeclimate.com/github/VictorAuthiat/derivation_endpoint)

DerivationEndpoint is a gem that provides a Rack app to redirect from an endpoint to another using custom strategies.
This can be useful when you want to expose private files with a public URL.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "derivation_endpoint"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install derivation_endpoint

## Usage

Here are the steps to follow to set up an endpoint derivation:

**Configuration**

```ruby
DerivationEndpoint.configure do |config|
  config.host    = "http://localhost:3000"
  config.prefix  = "derivation_endpoints"
  config.encoder = proc {}
  config.decoder = proc {}
end
```

**Mount the endpoint**

```ruby
mount DerivationEndpoint::Derivation.new => DerivationEndpoint.derivation_path
```

**Add a derivation endpoint**

```ruby
class Post < ApplicationRecord
  extend DerivationEndpoint

  derivation_endpoint :file, options: { foo: :bar }
end
```

Two methods will now be available:

 - `Post#file_derivation_url`
 - `Post#file_redirection_url`

In this example `file_derivation_url` returns the derivation endpoint URL.
This endpoint redirects to the `file_redirection_url` using your encoder and decoder procs.

## Examples

- [Shrine](https://github.com/VictorAuthiat/derivation_endpoint/tree/master/docs/shrine.md)
- [CarrierWave](https://github.com/VictorAuthiat/derivation_endpoint/tree/master/docs/carrierwave.md)
- ActiveStorage (WIP)
- PaperClip (WIP)
- Refile (WIP)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/victorauthiat/derivation_endpoint. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/victorauthiat/derivation_endpoint/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DerivationEndpoint project"s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/victorauthiat/derivation_endpoint/blob/master/CODE_OF_CONDUCT.md).
