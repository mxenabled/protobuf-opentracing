RSpec.describe Protobuf::Opentracing::Extensions::Client do
  before do
    ::OpenTracing.global_tracer = ::OpenTracingTestTracer.build
    server.subscribe
  end

  after do
    ::OpenTracing.global_tracer = ::OpenTracing::Tracer.new
    server.unsubscribe
    server.nats.close
  end

  let(:server) { ::Protobuf::Nats::Server.new(:threads => 1) }
  let(:client) { ::Protobuf::Rpc::Client.new(:service => TestService, :method => "test_search") }

  def spans
    ::OpenTracing.global_tracer.spans
  end

  def finished_spans
    spans.select(&:end_time)
  end

  describe "#operation_name" do
    it "uses the service name and request method for the operation name" do
      expect(client.operation_name).to eq "RPC TestService\#test_search"
    end
  end

  describe "#send_request" do
    it "tags the client span" do
      client.test_search(::TestRequest.new) do |c|
        c.on_complete do |_|
          tags = ::OpenTracing.global_tracer.spans.first.tags
          expect(tags["span.kind"]).to eq "client"
        end
      end
    end

    it "starts an active span if needed when making a request" do
      client.test_search(::TestRequest.new) do |c|
        c.on_complete do |_|
          expect(::OpenTracing.global_tracer.spans.first.operation_name).to eq client.operation_name
        end
      end
    end

    it "does not start an active span if one exists when making a request" do
      ::OpenTracing.start_active_span("testing") do
        client.test_search(::TestRequest.new) do |c|
          c.on_complete do |_|
            expect(::OpenTracing.global_tracer.spans.first.operation_name).to eq "testing"
          end
        end
      end
    end

    it "links spans in the expected hierarchy" do
      ::OpenTracing.start_active_span("testing") do
        client.test_search(::TestRequest.new) do |c|
          c.on_complete do |_|
            # Three spans: First one is the one we started in this test, second
            # is the one started by the client, and the third is the one
            # started by the server.
            expect(::OpenTracing.global_tracer.spans.size).to be 3

            manual_span = ::OpenTracing.global_tracer.spans[0]
            client_span = ::OpenTracing.global_tracer.spans[1]
            server_span = ::OpenTracing.global_tracer.spans[2]

            expect(client_span.context.parent_id).to eq manual_span.context.span_id
            expect(server_span.context.parent_id).to eq client_span.context.span_id
          end
        end
      end
    end

    it "finishes spans" do
      ::OpenTracing.start_active_span("testing") do
        client.test_search(::TestRequest.new) do |c|
          c.on_complete do |_|
            # The only finished span is the server's by the time we get a
            # response.
            expect(finished_spans.size).to be 1
          end
        end

        # Now we've left the client's context so its span has also been closed.
        expect(finished_spans.size).to be 2
      end

      # By this point we're outside of the "testing" active span's scope so
      # everything should be done.
      expect(finished_spans.size).to be 3
    end

    it "closes active spans" do
      client.test_search(::TestRequest.new) do |c|
        c.on_complete do |_|
          expect(::OpenTracing.active_span).to_not be_nil
        end
      end

      expect(::OpenTracing.active_span).to be_nil
    end
  end
end
