module LiveQA
  ##
  # == LiveQA \Message
  #
  # Return the base message for an event
  class Message
    class << self

      def base
        Util.deep_compact(
          message_id: SecureRandom.uuid,
          timestamp: Time.now.utc.iso8601(3),
          session_tracker_id: tracker_id
        )
      end

      def extended
        Util.deep_compact(
          tracker_id: tracker_id,
          library: library,
          server: server,
          request: LiveQA::Store.get(:request),
          worker: LiveQA::Store.get(:worker),
          stack: LiveQA::Store.get(:stack),
          environement: LiveQA::Store.get(:environement)
        ).merge(base)
      end

      private

      def tracker_id
        return LiveQA::Store.get(:tracker_id) if LiveQA::Store.exist?(:tracker_id)

        LiveQA::Store.set(:tracker_id, SecureRandom.uuid)
      end

      def library
        {
          name: LiveQA::LIBRARY_NAME,
          language: 'ruby',
          version: LiveQA::VERSION
        }
      end

      def server
        {
          host: Socket.gethostname,
          pid: Process.pid,
          software: LiveQA::Store.get(:server_software)
        }
      end

    end
  end
end
