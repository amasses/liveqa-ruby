module LiveQA
  ##
  # == LiveQA \API \Resource
  #
  # Define the API requests methods
  class APIResource < LiveQAObject
    ##
    # @return [String] resource name
    def resource_name
      self.class.resource_name
    end

    ##
    # @return [String] resource path
    def resource_path(path = nil)
      self.class.resource_path(path)
    end

    ##
    # Send a request to the API
    #
    # @param [Symbol] method for the request
    # @param [String] endpoint for the request
    # @param [Hash] options
    # @param [Hash] Payload
    #
    # @return [Hash] response
    # @raise [LiveQA::RequestError] if the request is invalid
    def request(method, resource_path, payload = {}, options = {})
      self.class.request(method, resource_path, payload, options)
    end

    class << self

      ##
      # @return [String] resource path
      def resource_path(path = nil)
        "/api/#{configurations.api_version}/#{path || @resource_name || CGI.escape(resource_name)}"
      end

      ##
      # @return [String] resource name
      def resource_name
        Util.underscore("#{class_name}s")
      end

      ##
      # @return [String] the class name
      def class_name
        name.split('::')[-1]
      end

      ##
      # Send a request to the API
      #
      # @param [Symbol] method for the request
      # @param [String] endpoint for the request
      # @param [Hash] options
      # @param [Hash] Payload
      #
      # @return [Hash] response
      # @raise [LiveQA::RequestError] if the request is invalid
      def request(method, path, payload = {}, options = {})
        payload    = Util.deep_obfuscate_value(payload, configurations.obfuscated_fields)
        url_params = Util.encode_parameters(payload) if method == :get
        uri        = build_endpoint_url(path, url_params)

        request_options = Util.compact(
          method:  method,
          url:     uri.to_s,
          payload: payload.to_json,
          proxy:   configurations.proxy_url,
          use_ssl: configurations.http_secure
        ).merge(headers(options)).merge(options)

        Request.execute(request_options).body
      rescue LiveQA::RequestError => error
        return error.http_body if error.http_status == 422
        raise
      end

      private

      def build_endpoint_url(path, params = nil)
        host, port = configurations.api_host.split(':')
        port       = port.to_i if port

        url_params = Util.compact(
          host:  host,
          path:  path,
          port:  port,
          query: params
        )

        return URI::HTTPS.build(url_params) if configurations.http_secure
        URI::HTTP.build(url_params)
      end

      def ssl_options
        return {} unless configurations.http_secure
        {
          ca_file:     File.expand_path(File.dirname(__FILE__) + '/../../vendor/cacert.pem'),
          verify_mode: OpenSSL::SSL::VERIFY_PEER
        }
      end

      def headers(options)
        {
          headers: {
            accept: 'application/json',
            content_type: 'application/json',
            x_account_token: options.delete(:account_token) || configurations.account_token,
            x_space_name: options.delete(:space_name) || configurations.space_name,
            x_environment_name: options.delete(:environment_name) || configurations.environment_name
          }
        }
      end

      def configurations
        LiveQA.configurations
      end

    end
  end
end
