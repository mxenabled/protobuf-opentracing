module Protobuf
  module Opentracing
    module Extensions
      module Client
        def send_request
          operation = "#{options[:service]}##{options[:method]}"
          ::OpenTracing.start_active_span(operation) do
            super
          end
        end
      end
    end
  end
end
