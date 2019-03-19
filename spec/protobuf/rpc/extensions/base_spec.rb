RSpec.describe Protobuf::Opentracing::Extensions::Base do
  nats_conn = ::Protobuf::Nats.client_nats_connection
  server = ::Protobuf::Nats::Server.new(:threads => 1, :client => nats_conn)

  before(:all) { server.subscribe }
  after(:all) { server.unsubscribe }

  it "includes tracing headers in request" do
    client = ::Protobuf::Rpc::Client.new(:service => TestService)
    client.test_search(::TestRequest.new) do |c|
      c.on_complete do |conn|
        carrier = {}
        ::OpenTracing.inject(::OpenTracing.active_span.context,
                             ::OpenTracing::FORMAT_TEXT_MAP,
                             carrier)

        expected_headers = carrier.keys
        expect(expected_headers).not_to be_empty

        returned_headers = conn.request_fields[:headers].map(&:key)
        expect(returned_headers).to include(*expected_headers)
      end
    end
  end
end
