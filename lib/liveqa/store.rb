module LiveQA
  ##
  # == LiveQA \Store
  #
  # Store environement data
  #
  class Store
    class << self

      def store
        Thread.current[:request_store] ||= {}
      end

      def clear!
        Thread.current[:request_store] = {}
      end

      def load_from_hash(object = {})
        clear!
        bulk_set(Util.deep_symbolize_key(object)) if object.is_a?(Hash)
      end

      def get(key)
        store[key]
      end
      alias [] get

      def set(key, value)
        store[key] = value
      end
      alias []= set

      def bulk_set(attributes = {})
        attributes.each do |(key, value)|
          set(key, value)
        end
      end

      def exist?(key)
        store.key?(key)
      end

      def delete(key, &block)
        store.delete(key, &block)
      end

    end
  end
end
