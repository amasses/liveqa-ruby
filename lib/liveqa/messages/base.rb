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
            identifier_id: LiveQA::Store.get(:identifier_id),
            message_id: SecureRandom.uuid,
            timestamp: Time.now.utc.iso8601,
            session_identifier_id: LiveQA::Store.get(:identifier_id)
          )
        end

      end
    end
  end
end
