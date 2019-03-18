module Protobuf
  module Opentracing
    module Extensions
      module Client
        extend Forwardable

        def_delegator :@connector, :send_request, :send_traced_request

        def send_request
          operation = "#{options[:service]}##{options[:method]}"
          ::OpenTracing.start_active_span(operation) do
            send_traced_request
          end
        end
      end
    end
  end
end
