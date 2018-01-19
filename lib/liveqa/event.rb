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
  end
end
