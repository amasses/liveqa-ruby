module LiveQA
  ##
  # == LiveQA \Object
  #
  # Define the API objects
  class LiveQAObject
    ##
    # @return [Hash] JSON parsed response
    attr_reader :raw

    ##
    # @return [Hash] JSON parsed response
    attr_reader :data

    attr_reader :errors

    attr_reader :successful
    alias successful? successful

    class << self

      ##
      # Initialize from the API response
      #
      # @return [LiveQA::LiveQAObject]
      def initialize_from(response, object = new)
        object.load_response_api(response.is_a?(Hash) ? response : JSON.parse(response))
        object.update_attributes(LiveQA::Util.except_keys(object.raw, :data))
        if object.raw[:object] == 'list'
          object.raw[:data].each do |response_object|
            data = object.type_from_string_object(response_object[:object]).initialize_from(response_object)

            object.add_data(data)
          end
        end

        object
      end

    end

    ##
    # Update the object based on the response from the API
    # Remove and new accessor
    #
    # @param [Hash] response
    #
    # @return [LiveQA::LiveQAObject]
    def update_from(response)
      self.class.initialize_from(response, self)

      (@values.keys - raw.keys).each { |key| remove_accessor(key) }

      self
    end

    ##
    # Initialize and create accessor for values
    #
    # @params [Hash] values
    def initialize(values = {})
      @data   = []
      @values = {}

      update_attributes(values)
    end

    ##
    # get attribute value
    def [](key)
      @values[key.to_sym]
    end

    ##
    # set attribute value
    def []=(key, value)
      send(:"#{key}=", value)
    end

    ##
    # @return [Array] all the keys
    def keys
      @values.keys
    end

    ##
    # @return [Hash] values to hash
    def to_hash
      @values
    end

    ##
    # @return [JSON] values to JSON
    def to_json(_object = nil)
      JSON.generate(@values)
    end

    ##
    # Update the attribute and add accessor for new attributes
    #
    # @param [Hash] values
    def update_attributes(attributes)
      attributes.each do |(key, value)|
        add_accessor(key, value)
      end
    end

    ##
    # Load the root components for the API response
    #
    # @param [Hash] values
    def load_response_api(response)
      @raw        = LiveQA::Util.deep_underscore_key(response)
      @successful = true
    end

    ##
    # Add data for sub-object
    #
    # @param [Object] data
    def add_data(data)
      @data << data
    end

    ##
    # Create an object from a string
    #
    # @param [String] object to be build
    #
    # @return [Object]
    def type_from_string_object(string_object)
      klass_name = LiveQA::Util.camelize(string_object.to_s)

      Object.const_get("LiveQA::#{klass_name}")
    end

    def inspect
      id_string = respond_to?(:id) && !id.nil? ? " id=#{id}" : ''
      "#<#{self.class}:0x#{object_id.to_s(16)}#{id_string}> JSON: " + JSON.pretty_generate(@values)
    end

    def method_missing(name, *args)
      super unless name.to_s.end_with?('=')

      attribute = name.to_s[0...-1].to_sym
      value     = args.first

      add_accessor(attribute, value)
    end

    private

    def add_accessors(keys, payload = raw)
      keys.each do |key|
        add_accessor(key, payload[key])
      end
    end

    def add_accessor(name, value)
      @values[name] = value

      define_singleton_method(name) { @values[name] }
      define_singleton_method(:"#{name}=") do |v|
        @values[name] = v
      end

      define_singleton_method(:"#{name}?") { value } if [FalseClass, TrueClass].include?(value.class)
    end

    def remove_accessor(name)
      @values.delete(name)

      singleton_class.class_eval { remove_method name.to_sym } if singleton_methods.include?(name.to_sym)
      singleton_class.class_eval { remove_method "#{name}=".to_sym } if singleton_methods.include?("#{name}=".to_sym)
      singleton_class.class_eval { remove_method "#{name}?".to_sym } if singleton_methods.include?("#{name}?".to_sym)
    end

  end
end
