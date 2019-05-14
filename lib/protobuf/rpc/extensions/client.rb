module Protobuf
  module Opentracing
    module Extensions
      module Client
        def send_request
          span = start_span
          options[:tracing_span] = span
          results = super
          span.finish
          results
        end

        def operation_name
          @operation_name ||= "#{options[:service]}##{options[:method]}"
        end

        def start_span
          tags = {
            "span.kind" => "client",
          }
          if ::OpenTracing.active_span
            ::OpenTracing.start_span(operation_name, :tags => tags)
          else
            ::OpenTracing.start_active_span(operation_name, :tags => tags).span
          end
        end
      end
    end
  end
end
