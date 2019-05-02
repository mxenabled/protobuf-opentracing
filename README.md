# Protobuf::Opentracing

Add service to service tracing with Opentracing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'protobuf-opentracing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install protobuf-opentracing

## Usage

When loaded, this gem injects itself into the RPC server and client flow to
include and handle tracing information on requests. See the
[`opentracing`](https://rubygems.org/gems/opentracing/) gem for additional
information.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome at
https://github.com/mxenabled/protobuf-opentracing.
