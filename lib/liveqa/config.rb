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
    # @return [String] http secure
    attr_accessor :http_secure

    ##
    # @param [Hash{Symbol=>Object}]
    # Initialize and validate the configuration
    def initialize(api_key: nil, proxy_url: nil, api_host: 'api.liveqa.io', api_version: 'v1', http_secure: true)
      self.api_key     = api_key
      self.api_host    = api_host
      self.api_version = api_version
      self.proxy_url   = proxy_url
      self.http_secure = http_secure
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
