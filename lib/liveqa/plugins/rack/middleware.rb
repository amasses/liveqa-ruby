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
          store_stack

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

        # rubocop:disable Metrics/MethodLength
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
            get_params: Util.deep_obfuscate_value(
              request.GET,
              LiveQA.configurations.obfuscated_fields
            ),
            post_params: Util.deep_obfuscate_value(
              request.POST,
              LiveQA.configurations.obfuscated_fields
            )
          )

          LiveQA::Store.bulk_set(
            server_software: request.env['SERVER_SOFTWARE']
          )
        end
        # rubocop:enable Metrics/MethodLength

        def store_stack
          stack = LiveQA::Store.get(:stack) || []

          LiveQA::Store.set(
            :stack,
            stack.push(
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

          return url if params.blank?

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
