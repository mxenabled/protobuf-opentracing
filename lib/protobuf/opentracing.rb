require "protobuf/opentracing/version"
require "protobuf/opentracing/request_decoder"

module Protobuf
  module Opentracing
    ::ActiveSupport.on_load(:protobuf_rpc_middleware) do |rpc|
      rpc.middleware.insert_after(::Protobuf::Rpc::Middleware::RequestDecoder, Opentracing::RequestDecoder)
    end
  end
end

module Protobuf
  module Opentracing
    module Extensions
      module Base
        def request_bytes
          binding.pry
          trace_carrier = {}
          ::OpenTracing.inject(::OpenTracing.active_span.context,
                               ::OpenTracing::FORMAT_TEXT_MAP,
                               trace_carrier)
          trace = ::Protobuf::Socketrpc::Trace.new(:raw => JSON.generate(trace_carrier))

          validate_request_type!
          fields = { :service_name => @options[:service].name,
                     :method_name => @options[:method].to_s,
                     :request_proto => @options[:request],
                     :caller => request_caller,
                     :trace => trace }

          return ::Protobuf::Socketrpc::Request.encode(fields)
        rescue => e
          failure(:INVALID_REQUEST_PROTO, "Could not set request proto: #{e.message}")
        end
      end

      module Client
        extend Forwardable

        def_delegator :@connector, :send_request, :send_traced_request

        def send_request
          options
          binding.pry
          ::OpenTracing.start_active_span("testing") do |scope|
            send_traced_request
          end
        end
      end
    end
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
