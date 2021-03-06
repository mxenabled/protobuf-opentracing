module Protobuf
  module Opentracing
    module Extensions
      module Base
        def request_fields
          return super if options[:tracing_span].nil?

          trace_carrier = {}
          ::OpenTracing.inject(options[:tracing_span].context,
                               ::OpenTracing::FORMAT_TEXT_MAP,
                               trace_carrier)

          trace_headers = trace_carrier.map do |header|
            ::Protobuf::Socketrpc::Header.new(:key => header[0],
                                              :value => header[1])
          end

          fields = super
          headers = fields[:headers] || []
          fields[:headers] = headers + trace_headers
          fields
        end
      end
    end
  end
end
