module LiveQA
  ##
  # == LiveQA \Watcher
  #
  # Create and update groups
  #
  # @example: Usage
  #
  #   request = LiveQA::Watcher.create(template_flow: 'My Flow', expected_times: 42) #=> #<LiveQA::Response...>
  #
  class Watcher < APIResource
    include LiveQA::APIOperation::Save
  end
end
