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

          store_identifier(request)
          store_request_data(request)

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

        def store_identifier(request)
          LiveQA::Store.set(
            :identifier_id,
            request.cookies[identifier_id_name] || SecureRandom.uuid
          )
        end

        def store_request_data(request)
          LiveQA::Store.bulk_set(
            url:        request.url,
            ssl:        request.ssl?,
            host:       request.host,
            port:       request.port,
            path:       request.path,
            referrer:   request.referrer,
            method:     request.request_method,
            xhr:        request.xhr?,
            user_agent: request.user_agent,
            ip:         request.ip
          )
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
