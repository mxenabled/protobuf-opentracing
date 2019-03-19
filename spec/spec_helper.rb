require "bundler/setup"

require "protobuf"
require "protobuf/nats"
require "protobuf/opentracing"

require "test_service"

ENV["PROTOBUF_NATS_CONFIG_PATH"] = "./spec/support/protobuf_nats.yml"
ENV["PB_NATS_SERVER_SLOW_START_DELAY"] = "0.1"

::Protobuf.connector_type_class = ::Protobuf::Nats::Client
::Protobuf::Nats.start_client_nats_connection
::Protobuf::Logging.logger.level = ::Logger::UNKNOWN

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
