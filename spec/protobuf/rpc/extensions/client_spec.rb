RSpec.describe Protobuf::Opentracing::Extensions::Client do
  server = nil

  before do
    ::OpenTracing.global_tracer = ::OpenTracingTestTracer.build
  end

  before(:all) do
    server = ::Protobuf::Nats::Server.new(:threads => 1)
    server.subscribe
  end

  after(:all) do
    ::OpenTracing.global_tracer = ::OpenTracing::Tracer.new
    server.unsubscribe
    server.nats.close
  end

  let(:client) { ::Protobuf::Rpc::Client.new(:service => TestService, :method => "test_search") }

  describe "#operation_name" do
    it "uses the service name and request method for the operation name" do
      expect(client.operation_name).to eq "TestService\#test_search"
    end
  end

  describe "#send_request" do
    it "starts a new active span when making a request" do
      client.test_search(::TestRequest.new) do |c|
        c.on_complete do |_|
          expect(::OpenTracing.active_span.operation_name).to eq client.operation_name
        end
      end
    end

    it "does not start a new active span when one has already been created" do
      ::OpenTracing.start_active_span("testing") do
        client.test_search(::TestRequest.new) do |c|
          c.on_complete do |_|
            expect(::OpenTracing.active_span.operation_name).to eq "testing"
          end
        end
      end
    end

    it "does not start a span when the active span is for the same operation" do
      ::OpenTracing.start_active_span("TestService#test_search") do
        client.test_search(::TestRequest.new) do |c|
          c.on_complete do |_|
            # Two spans, one started by the client and the second by the server.
            expect(::OpenTracing.global_tracer.spans.size).to be 2
          end
        end
      end
    end
  end
end
