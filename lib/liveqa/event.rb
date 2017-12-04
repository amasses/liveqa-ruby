module LiveQA
  ##
  # == LiveQA \Event
  #
  # @example: Usage
  #
  #   request = LiveQA::Event.create('Event Name') #=> #<LiveQA::Response...>
  #
  class Event < APIResource
    include LiveQA::APIOperation::Save

    class << self

      def build_payload(payload)
        payload
          .merge(Messages::Base.to_h)
          .merge(context: Messages::Context.to_h)
      end

    end
  end
end
