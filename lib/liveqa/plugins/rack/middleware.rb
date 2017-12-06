module LiveQA
  module Plugins
    module Rack
      ##
      # LiveQA \Plugins \Rack \Middleware
      #
      # Middleware for Rack
      #
      class Middleware

        def initialize(app)
          @app = app
        end

        def call(env)
          request = ::Rack::Request.new(env)
          LiveQA::Store.set(:identifier_id, extract_identifier_id(request))

          status, headers, body = @app.call(env)

          write_cookie_identifier_id!(headers)

          [status, headers, body]
        ensure
          LiveQA::Store.clear!
        end

        private

        def identifier_id_name
          'fl_identifier_id'.freeze
        end

        def extract_identifier_id(request)
          request.cookies[identifier_id_name] ||
            SecureRandom.uuid
        end

        def write_cookie_identifier_id!(headers)
          ::Rack::Utils.set_cookie_header!(
            headers || {},
            identifier_id_name,
            value: LiveQA::Store.get(:identifier_id),
            path: '/'
          )
        end

      end
    end
  end
end
