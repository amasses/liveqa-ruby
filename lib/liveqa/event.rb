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

      ##
      # Send an event to the server
      #
      # @param [String] event name
      # @param [Hash] properties
      # @param [Hash] request_options
      #
      # @return [LiveQA::Response] with the response from the server
      def create(name, params = {}, properties = {}, request_options = {})
        payload = {
          name:       name,
          message_id: SecureRandom.uuid,
          properties: properties,
          context:    context,
          timestamp:  Time.now.to_i
        }.merge(params)

        super(payload, request_options)
      end

      private

      ##
      # Set the context of the event
      def context
        {
          library: {
            name:     LiveQA::LIBRARY_NAME,
            language: 'ruby',
            version:  LiveQA::VERSION
          }
        }
      end

    end
  end
end
