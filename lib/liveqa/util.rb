module LiveQA
  module Util
    class << self

      DATE_FORMAT = '%Y/%m/%d'.freeze
      OBFUSCATED  = '[HIDDEN]'.freeze

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
            result[key] = value if !value.nil?
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
      def deep_obfuscate_value(object, fields)
        case object
        when Hash
          object.each_with_object({}) do |(key, value), result|
            result[key] = fields.include?(key.to_s) ? OBFUSCATED : deep_obfuscate_value(value, fields)
          end
        when Array
          object.map { |e| deep_obfuscate_value(e, fields) }
        else
          object
        end
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

    end
  end
end
