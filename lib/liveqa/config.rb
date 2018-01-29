module LiveQA
  ##
  # == LiveQA \Config
  #
  # Represent the LiveQA configuration for the API
  class Config

    ASYNC_HANDLERS = {
      sidekiq: {
        class:   'LiveQA::AsyncHandlers::Sidekiq',
        require: 'liveqa/async_handlers/sidekiq'
      }
    }.freeze

    DEFAULT_OBFUSCATED_FIELDS = %w[
      password
      password_confirmation
      secret
      secret_token
      authenticity_token
      token
      api_key
      access_token
      credit_card_number
      cvv
      ccv
    ].freeze

    ##
    # @return [String] API account token
    attr_accessor :account_token

    ##
    # @return [String] API environement token
    attr_accessor :environement_token

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
    # @return [Array[String]] fields to obfuscate
    attr_accessor :obfuscated_fields

    ##
    # @return [Null|Symbol|Proc] asynchronous handler
    attr_accessor :async_handler

    ##
    # @return [Hash] options for asynchronous handler
    attr_accessor :async_options

    ##
    # @return [Hash] custom object properties
    attr_accessor :custom_object_properties

    ##
    # @return [Hash] metadata to be attach to the payload
    attr_accessor :metadata

    ##
    # @param [Hash{Symbol=>Object}]
    # Initialize and validate the configuration
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def initialize(options = {})
      self.account_token = options[:account_token]
      self.environement_token = options[:environement_token]
      self.api_host = options[:api_host] || 'api.liveqa.io'
      self.api_version = options[:api_version] || 'v1'
      self.proxy_url = options[:proxy_url]
      self.http_secure = options[:http_secure] || true
      self.enabled = options[:enabled] || true
      self.obfuscated_fields = options[:obfuscated_fields] || []
      self.async_handler = options[:async_handler]
      self.async_options = options[:async_options] || {}
      self.custom_object_properties = options[:custom_object_properties] || {}
      self.metadata = options[:metadata]
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    ##
    # validate the configuration
    # Raise when configuration are not valid
    # @return [Boolean] true
    def valid!
      format!

      %i[account_token environement_token api_host api_version].each do |field|
        validate_presence(field)
      end

      true
    end

    private

    ##
    # Format configuration fields
    #
    # * Set obfuscated_fields to string
    # * Change to the class for async handler
    #
    def format!
      self.obfuscated_fields = (obfuscated_fields.map(&:to_s) + DEFAULT_OBFUSCATED_FIELDS).uniq

      return unless ASYNC_HANDLERS[async_handler]

      require ASYNC_HANDLERS[async_handler][:require]
      self.async_handler = Object.const_get(ASYNC_HANDLERS[async_handler][:class]).new(async_options)
    end

    def validate_presence(field)
      raise LiveQA::ConfigurationError, "#{field} can't be blank" if send(field).nil? || send(field).empty?
    end

  end
end
