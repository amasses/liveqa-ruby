require 'uri'

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

          store_tracker(request)
          store_request_data(request)
          store_framework

          LiveQA::Plugins::Rails::MiddlewareData.store_data(request) if defined?(::Rails)

          status, headers, body = @app.call(env)

          write_cookie_tracker_id!(headers)

          [status, headers, body]
        ensure
          LiveQA::Store.clear!
        end

        private

        def tracker_id_name
          'liveqa_tracker_id'.freeze
        end

        def store_tracker(request)
          LiveQA::Store.set(
            :tracker_id,
            request.cookies[tracker_id_name] || SecureRandom.uuid
          )
        end

        def store_request_data(request)
          LiveQA::Store.set(
            :request,
            url: obfuscate_uri(request.url),
            ssl: request.ssl?,
            host: request.host,
            port: request.port,
            path: request.path,
            referrer: obfuscate_uri(request.referrer),
            method: request.request_method,
            xhr: request.xhr?,
            user_agent: request.user_agent,
            ip: request.ip,
            params: Util.deep_obfuscate_value(
              ::Rack::Utils.parse_query(request.query_string),
              LiveQA.configurations.obfuscated_fields
            )
          )

          LiveQA::Store.bulk_set(
            server_software: request.env['SERVER_SOFTWARE']
          )
        end

        def store_framework
          frameworks = LiveQA::Store.get(:frameworks) || []

          LiveQA::Store.set(
            :frameworks,
            frameworks.push(
              name: 'rack',
              version: ::Rack.version
            )
          )
        end

        def write_cookie_tracker_id!(headers)
          ::Rack::Utils.set_cookie_header!(
            headers || {},
            tracker_id_name,
            value: LiveQA::Store.get(:tracker_id),
            path: '/'
          )
        end

        def obfuscate_uri(url)
          uri = URI.parse(url)

          params =
            Util.deep_obfuscate_value(
              ::Rack::Utils.parse_query(uri.query),
              LiveQA.configurations.obfuscated_fields,
              'HIDDEN'
            )

          uri.merge(
            "?#{::Rack::Utils.build_query(params)}"
          ).to_s
        rescue
          ''
        end

      end
    end
  end
end
