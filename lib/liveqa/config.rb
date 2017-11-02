module LiveQA
  ##
  # == LiveQA \Config
  #
  # Represent the LiveQA configuration for the API
  class Config

    ##
    # @return [String] API key
    attr_accessor :api_key

    ##
    # @return [String] API host
    attr_accessor :api_host

    ##
    # @return [String] API version
    attr_accessor :api_version

    ##
    # @return [String] proxy url
    attr_accessor :proxy_url

    ##
    # @return [Boolean] http secure
    attr_accessor :http_secure

    ##
    # @return [Boolean] service is enable
    attr_accessor :enabled

    ##
    # @param [Hash{Symbol=>Object}]
    # Initialize and validate the configuration
    def initialize(options = {})
      self.api_key     = options[:api_key]
      self.api_host    = options[:api_host] || 'api.liveqa.io'
      self.api_version = options[:api_version] || 'v1'
      self.proxy_url   = options[:proxy_url]
      self.http_secure = options[:http_secure] || true
      self.enabled     = options[:enabled] || true
    end

    ##
    # validate the configuration
    # Raise when configuration are not valid
    # @return [Boolean] true
    def valid!
      %i[api_key api_host api_version].each do |field|
        validate_presence(field)
      end

      true
    end

    private

    def validate_presence(field)
      raise LiveQA::ConfigurationError, "#{field} can't be blank" if send(field).nil? || send(field).empty?
    end

  end
end
