RSpec.describe Protobuf::Opentracing::Extensions::Base do
  server = nil

  before(:all) do
    server = ::Protobuf::Nats::Server.new(:threads => 1)
    server.subscribe
  end

  after(:all) do
    server.unsubscribe
    server.nats.close
  end

  let(:client) { ::Protobuf::Rpc::Client.new(:service => TestService) }

  it "includes tracing headers in request" do
    cb_called = false

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

        cb_called = true
      end
    end

    expect(cb_called).to be true
  end

  it "starts an active span on the server that is a child of the client span" do
    cb_called = false

    client.test_search(::TestRequest.new) do |c|
      c.on_success do |ret|
        expect(::OpenTracing.active_span.context.span_id.to_s).to eq(ret.parent_span_id)
        cb_called = true
      end
    end

    expect(cb_called).to be true
  end
end
