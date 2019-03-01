require "active_support"

require "protobuf/opentracing/version"
require "protobuf/opentracing/request_decoder"

module Protobuf
  module Opentracing
  end
end

::ActiveSupport.on_load(:protobuf_rpc_middleware) do |rpc|
  rpc.middleware.insert_after(::Protobuf::Rpc::Middleware::RequestDecoder, ::Protobuf::Opentracing::RequestDecoder)
end
