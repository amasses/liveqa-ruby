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
          store_request_data(request, env)
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

        def store_request_data(request, env)
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
            get_params: obfuscation_get_params(request, 'GET'),
            post_params: obfuscation_get_params(request, 'POST'),
            headers: obfuscate_headers(env)
          )

          LiveQA::Store.bulk_set(
            server_software: request.env['SERVER_SOFTWARE']
          )
        end

        def store_stack
          stack = LiveQA::Store.get(:stack) || []
          return if stack.any? { |values| values[:name] == 'rack' }

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

        def obfuscation_get_params(request, type)
          Util.deep_obfuscate_value(
            request.send(type),
            LiveQA.configurations.obfuscated_fields
          )
        rescue
          {}
        end

        def obfuscate_headers(env)
          skip_headers = %w[HTTP_USER_AGENT HTTP_COOKIE HTTP_REFERER HTTP_HOST]

          headers = env.keys.grep(/^HTTP_|^CONTENT_TYPE$|^CONTENT_LENGTH$/).each_with_object({}) do |key, hash|
            next if skip_headers.include?(key)
            name = key.gsub(/^HTTP_/, '').split('_').map(&:capitalize).join('-')

            hash[name] = env[key]
          end

          Util.deep_obfuscate_value(
            headers,
            LiveQA.configurations.obfuscated_fields
          )
        rescue
          {}
        end

      end
    end
  end
end
