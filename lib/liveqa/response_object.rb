module LiveQA
  ##
  # == Response \Object
  #
  # Build the object from the API response
  module ResponseObject

    ##
    # @return [String] raw data
    attr_accessor :raw_data

    ##
    # @return [Hash{Symbol=>Object}] payload
    attr_accessor :payload

    ##
    # @param [String] response values
    def initialize_from(response_values)
      @raw_data = response_values
      data      = response_values.is_a?(Hash) ? response_values : JSON.parse(raw_data)
      @payload  = deep_underscore_key(data)

      add_accessors(payload.keys)

      self
    end

    protected

    ##
    # Add accessor for keys
    # @param [Array] keys
    def add_accessors(keys)
      keys.each do |key|
        self.class.send(:define_method, key) { payload[key] }

        if [FalseClass, TrueClass].include?(payload[key].class)
          define_method(:"#{key}?") { payload[key] }
        end
      end
    end

    private

    def deep_underscore_key(hash_object)
      hash_object.deep_transform_keys do |key|
        begin
          key.underscore.to_sym
        rescue
          key
        end
      end
    end

  end
end
