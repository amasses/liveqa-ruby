module LiveQA
  module Util
    class << self

      DATE_FORMAT = '%Y/%m/%d'.freeze
      OBFUSCATED = '[HIDDEN]'.freeze
      DEFAULT_OBJECT_DEF = %w[id name].freeze

      ##
      # Remove keys from a Hash
      #
      # @param [Hash] to be excepted
      # @param [List[String]] to be excepted
      #
      # @return [Hash]
      def except_keys(hash, *keys)
        hash.dup.delete_if { |(key, _value)| keys.include?(key) }
      end

      ##
      # Convert string to camelize
      #
      # @param [String]
      #
      # @example
      #   camelize('my_model') => 'MyModel'
      def camelize(string)
        string.split('_').map(&:capitalize).join
      end

      ##
      # Remove nil value from hash
      #
      # @return [Hash]
      def compact(hash)
        hash.reject { |_, value| value.nil? }
      end

      ##
      # Remove nil value from hash recursively
      #
      # @return [Hash]
      def deep_compact(object)
        object.each_with_object({}) do |(key, value), result|
          if value.is_a?(Hash)
            value = deep_compact(value)
            result[key] = value if !value.nil? && !value.empty?
          else
            result[key] = value unless value.nil?
          end
        end
      end

      ##
      # Encodes a hash of parameters in a way that's suitable for use as query
      # parameters in a URI or as form parameters in a request body. This mainly
      # involves escaping special characters from parameter keys and values (e.g.
      # `&`).
      def encode_parameters(params = {})
        params.map { |k, v| "#{url_encode(k)}=#{url_encode(v)}" }.join('&')
      end

      ##
      # Encodes a string in a way that makes it suitable for use in a set of
      # query parameters in a URI or in a set of form parameters in a request
      # body.
      def url_encode(key)
        CGI.escape(key.to_s).gsub('%5B', '[').gsub('%5D', ']')
      end

      ##
      # Convert string to underscore
      #
      # @param [String]
      #
      # @example
      #   underscore('MyModel') => 'my_model'
      def underscore(string)
        string
          .gsub(/::/, '/')
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr('-', '_')
          .downcase
      end

      ##
      # Deep convert hash to underscore case keys
      #
      # @param [Hash] hash to transform
      #
      # @return [Hash] transformed
      def deep_underscore_key(hash_object)
        deep_transform_keys_in_object(hash_object) do |key|
          begin
            underscore(key).to_sym
          rescue
            key
          end
        end
      end

      ##
      # Deep convert hash to string keys
      #
      # @param [Hash] hash to transform
      #
      # @return [Hash] transformed
      def deep_stringify_key(hash_object)
        deep_transform_keys_in_object(hash_object) do |key|
          begin
            key.to_s
          rescue
            key
          end
        end
      end

      ##
      # Deep convert hash to symbol keys
      #
      # @param [Hash] hash to transform
      #
      # @return [Hash] transformed
      def deep_symbolize_key(hash_object)
        deep_transform_keys_in_object(hash_object) do |key|
          begin
            key.to_sym
          rescue
            key
          end
        end
      end

      ##
      # Deep remove key from hash
      #
      # @param [Hash] hash to obfuscate
      #
      # @return [Hash] hash obfuscated
      def deep_obfuscate_value(object, fields, obfuscate_name = OBFUSCATED)
        case object
        when Hash
          object.each_with_object({}) do |(key, value), result|
            result[key] = fields.include?(key.to_s) ? obfuscate_name : deep_obfuscate_value(value, fields)
          end
        when Array
          object.map { |e| deep_obfuscate_value(e, fields) }
        else
          object
        end
      end

      ##
      # Convert object into Hash
      #
      # @params [Objects]
      #
      # @return [Hash]
      def properties(*args)
        params = extract_params!(args)

        attributes = params.each_with_object({}) do |(key, value), hash|
          hash[key] = extract_object(value)
        end

        attributes.merge(
          args.each_with_object({}) do |object, hash|
            key = object.class.name.downcase
            next if key.nil?

            hash[key] = extract_object(object)
          end
        )
      end

      private

      def deep_transform_keys_in_object(object, &block)
        case object
        when Hash
          object.each_with_object({}) do |(key, value), result|
            result[yield(key)] = deep_transform_keys_in_object(value, &block)
          end
        when Array
          object.map { |e| deep_transform_keys_in_object(e, &block) }
        else
          object
        end
      end

      def extract_object(object, custom_object_properties = LiveQA.configurations.custom_object_properties)
        return unless object

        object_name = object.class.name.downcase

        columns =
          custom_object_properties[object_name.to_sym] ||
          custom_object_properties[object_name.to_s] ||
          DEFAULT_OBJECT_DEF

        params = columns.each_with_object({}) do |column, attributes|
          attributes[column.to_s] = object.send(column) if object.respond_to?(column)
        end

        params.empty? ? object : params
      end

      def extract_params!(args)
        if args.last.is_a?(Hash) && args.last.instance_of?(Hash)
          args.pop
        else
          {}
        end
      end

    end
  end
end
