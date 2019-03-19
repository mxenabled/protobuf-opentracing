RSpec.describe Protobuf::Opentracing::Extensions::Client do
  it "starts a new active span when making a request" do
    expect(::OpenTracing).to receive(:start_active_span).with("TestService#test_search")
    client = ::Protobuf::Rpc::Client.new({ :service => TestService })
    client.test_search(::TestRequest.new)
  end
end
