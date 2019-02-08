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
        parent = nil
        operation = "#{env.service_name}##{env.method_name}"

        unless headers.nil?
          parent = ::OpenTracing.extract(::OpenTracing::FORMAT_TEXT_MAP, headers)
        end

        if parent.nil?
          ::OpenTracing.start_active_span(operation) do
            result = app.call(env)
          end
        else
          ::OpenTracing.start_active_span(operation, :child_of => parent) do
            result = app.call(env)
          end
        end

        result
      end

      def headers
        return nil if env.request_wrapper.nil?
        @headers ||= env.request_wrapper.headers.reduce({}) do |ctx, header|
          ctx[header.key] = header.value
          ctx
        end
      end
    end
  end
end
