module Protobuf
  module Opentracing
    class RequestDecoder
      attr_reader :app, :env

      def initialize(app)
        @app = app
      end

      def call(env)
        operation = "#{env.service_name}##{env.method_name}"
        headers = request_headers(env)
        parent = ::OpenTracing.extract(::OpenTracing::FORMAT_TEXT_MAP, headers)
        options = {}
        options[:child_of] = parent unless parent.nil?
        result = nil

        ::OpenTracing.start_active_span(operation, options) do
          result = app.call(env)
        end

        result
      end

      def request_headers(env)
        return nil if env.request_wrapper.nil?
        env.request_wrapper.headers.reduce({}) do |ctx, header|
          ctx[header.key] = header.value
          ctx
        end
      end
    end
  end
end
