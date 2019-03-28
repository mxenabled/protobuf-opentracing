class TestRequest < ::Protobuf::Message
end

class TestResponse < ::Protobuf::Message
  optional :string, :parent_span_id, 1
end

class TestService < ::Protobuf::Rpc::Service
  rpc :test_search, TestRequest, TestResponse

  def test_search
    response = { :parent_span_id => ::OpenTracing.active_span.context.parent_id.to_s }
    respond_with response
  end
end
