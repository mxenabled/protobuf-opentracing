require "bundler/setup"

require "protobuf"
require "protobuf/nats"
require "protobuf/opentracing"

require "test_service"

# Ensure we load the testing configuration
ENV["PROTOBUF_NATS_CONFIG_PATH"] = "./spec/support/protobuf_nats.yml"

# For testing purposes we only need a single subscription per endpoint. Note
# that if this is ever increased, the slow start delay should most likely be
# decreased. See `PB_NATS_SERVER_SLOW_START_DELAY`.
ENV["PB_NATS_SERVER_SUBSCRIPTIONS_PER_RPC_ENDPOINT"] = "1"

# Use the NATS client by default and start the connection to the NATS server.
# If this fails make sure that a NATS server is running and the configuration
# found in `PROTOBUF_NATS_CONFIG_PATH` is correct.
::Protobuf.connector_type_class = ::Protobuf::Nats::Client
::Protobuf::Nats.start_client_nats_connection

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
