require "opentracing"

module Protobuf
  module Opentracing
    class InjectTrace
      attr_reader :app

      def initialize(app)
        @app = app
      end

      def call(env)
        env.request_wrapper.headers = headers_with_trace(env)
        app.call(env)
      end

      def headers_with_trace(env)
        trace_carrier = {}
        ::OpenTracing.inject(::OpenTracing.active_span.context,
                             ::OpenTracing::FORMAT_TEXT_MAP,
                             trace_carrier)

        trace_headers = trace_carrier.map do |header|
          ::Protobuf::Socketrpc::Header.new(:key => header[0],
                                            :value => header[1])
        end

        trace_headers.concat(env.request_wrapper.headers || [])
      end
    end
  end
end
