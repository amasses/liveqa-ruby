module LiveQA
  ##
  # == LiveQA \Group
  #
  # Create and update groups
  #
  # @example: Usage
  #
  #   request = LiveQA::Group.update('dc0b28d8a220', properties: { name: 'My Group' }) #=> #<LiveQA::Response...>
  #
  class Group < APIResource
    include LiveQA::APIOperation::Save
  end
end
