module Protobuf
  module Opentracing
    module Extensions
      module Client
        def send_request
          span = start_span
          results = super
          span.finish
          results
        end

        def operation_name
          @operation_name ||= "#{options[:service]}##{options[:method]}"
        end

        def start_span
          if ::OpenTracing.active_span
            ::OpenTracing.start_span(operation_name)
          else
            ::OpenTracing.start_active_span(operation_name).span
          end
        end
      end
    end
  end
end
