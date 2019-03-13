require "active_support"

require "protobuf/opentracing/inject_trace"
require "protobuf/opentracing/request_decoder"
require "protobuf/opentracing/version"

module Protobuf
  module Opentracing
  end
end

::ActiveSupport.on_load(:protobuf_rpc_middleware) do |rpc|
  rpc.middleware.insert_after(::Protobuf::Rpc::Middleware::RequestDecoder, ::Protobuf::Opentracing::RequestDecoder)
end

::ActiveSupport.on_load(:protobuf_rpc_client_middleware) do |rpc|
  rpc.client_middleware.insert_after(::Protobuf::Rpc::Middleware::Client::Logger, ::Protobuf::Opentracing::InjectTrace)
end
