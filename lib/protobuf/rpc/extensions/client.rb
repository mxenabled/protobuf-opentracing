module Protobuf
  module Opentracing
    module Extensions
      module Client
        def send_request
          scope, span = start_span
          options[:tracing_span] = span
          super
        ensure
          if scope
            scope.close
          else
            span.finish
          end
        end

        def operation_name
          @operation_name ||= "RPC #{options[:service]}##{options[:method]}"
        end

        def start_span
          tags = {
            "span.kind" => "client",
            "component" => "Protobuf",
          }
          if ::OpenTracing.active_span
            [nil, ::OpenTracing.start_span(operation_name, :tags => tags)]
          else
            scope = ::OpenTracing.start_active_span(operation_name, :tags => tags)
            [scope, scope.span]
          end
        end
      end
    end
  end
end
