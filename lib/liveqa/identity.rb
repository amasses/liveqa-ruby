module LiveQA
  ##
  # == LiveQA \Identity
  #
  # Create and update groups
  #
  # @example: Usage
  #
  #   request = LiveQA::Identity.set('dc0b28d8a220', properties: { name: 'My Identity' }) #=> #<LiveQA::Response...>
  #
  class Identity < APIResource
    @resource_name = 'identities'

    include LiveQA::APIOperation::Save
  end
end
