module LiveQA
  class Messages
    ##
    # == LiveQA \Messages \Base
    #
    # Return the context for an event
    class Base

      class << self

        def to_h
          Util.compact(
            tracker_id: tracker_id,
            message_id: SecureRandom.uuid,
            timestamp: Time.now.utc.iso8601,
            session_tracker_id: LiveQA::Store.get(:tracker_id)
          )
        end

        private

        def tracker_id
          return LiveQA::Store.get(:tracker_id) if LiveQA::Store.exist?(:tracker_id)

          LiveQA::Store.set(:tracker_id, SecureRandom.uuid)
        end

      end
    end
  end
end
