require "active_support"
require "opentracing"

require "protobuf/opentracing/request_decoder"
require "protobuf/opentracing/version"
require "protobuf/rpc/extensions/base"
require "protobuf/rpc/extensions/client"

module Protobuf
  module Opentracing
  end
end

module Protobuf
  module Rpc
    module Connectors
      class Base
        prepend ::Protobuf::Opentracing::Extensions::Base
      end
    end

    class Client
      prepend ::Protobuf::Opentracing::Extensions::Client
    end
  end
end

::ActiveSupport.on_load(:protobuf_rpc_middleware) do |rpc|
  rpc.middleware.insert_after(::Protobuf::Rpc::Middleware::RequestDecoder, ::Protobuf::Opentracing::RequestDecoder)
end
