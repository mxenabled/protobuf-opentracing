class TestRequest < ::Protobuf::Message; end
class TestResponse < ::Protobuf::Message; end

class TestService < ::Protobuf::Rpc::Service
  rpc :test_search, TestRequest, TestResponse

  def test_search
  end
end
