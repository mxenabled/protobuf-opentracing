class TestRequest < ::Protobuf::Message
end

class KeyValue < ::Protobuf::Message
  optional :string, :key, 1
  optional :string, :value, 2
end

class TestResponse < ::Protobuf::Message
  optional :string, :parent_span_id, 1
  repeated KeyValue, :tags, 2
end

class TestService < ::Protobuf::Rpc::Service
  rpc :test_search, TestRequest, TestResponse

  def test_search
    active_span = ::OpenTracing.active_span
    parent_span_id = active_span.context.parent_id.to_s
    tags = active_span.tags.map { |t| KeyValue.new(:key => t.key, :value => t.vStr) }
    response = {
      :parent_span_id => parent_span_id,
      :tags => tags,
    }
    respond_with response
  end
end
