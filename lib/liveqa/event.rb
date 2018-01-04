module LiveQA
  ##
  # == LiveQA \Event
  #
  # Accepted Methods:
  #
  # * update
  #
  # @example: Usage
  #
  #   request = LiveQA::Event.create('Event Name') #=> #<LiveQA::Response...>
  #
  class Event < APIResource
    include LiveQA::APIOperation::Save

    class << self

      def build_payload(payload)
        Message
          .to_h
          .merge(payload)
      end

    end
  end
end
