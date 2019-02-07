module Protobuf
  module Opentracing
    class RequestDecoder
      attr_reader :app, :env

      def initialize(app)
        @app = app
      end

      def call(env)
        dup._call(env)
      end

      def _call(env)
        @env = env

        result = nil
        operation = "#{env.service_name}##{env.method_name}"

        if trace_context.nil?
          ::OpenTracing.start_active_span(operation) do
            result = app.call(env)
          end
        else
          trace = ::OpenTracing.extract(::OpenTracing::FORMAT_TEXT_MAP, trace_context)

          ::OpenTracing.start_active_span(operation, :child_of => trace) do
            result = app.call(env)
          end
        end

        result
      end

      def trace_context
        return nil if env.request_wrapper.trace.nil?
        @trace_context ||= JSON.parse(env.request_wrapper.trace.raw)
      end
    end
  end
end
