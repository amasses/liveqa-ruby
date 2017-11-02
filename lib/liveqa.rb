require 'securerandom'
require 'net/http'
require 'ostruct'
require 'json'

require 'liveqa/version'
require 'liveqa/library_name'
require 'liveqa/util'
require 'liveqa/config'
require 'liveqa/errors'
require 'liveqa/liveqa_object'
require 'liveqa/request'
require 'liveqa/api_resource'

# Operations
require 'liveqa/api_operation/save'

# Resources
require 'liveqa/event'

##
# Implementation of the LiveQA
module LiveQA
  class << self

    ##
    # @return [LiveQA::Config] configurations
    attr_reader :configurations

    ##
    # Configures the LiveQA API
    #
    # @example Default configuration
    #   LiveQA.configure do |config|
    #     config.api_key   = 'your-api-key'
    #   end
    def configure
      yield @configurations = LiveQA::Config.new

      LiveQA.configurations.valid!
    end

    ##
    # Send a track event to the server
    #
    # @param [String] event name
    # @param [Hash] params of the hash. eg: user_id, identifier_id, ...
    # @param [Hash] properties of the event. eg: total_amount, ...
    #
    # @return [LiveQA::Object] response from the server
    def track(name, params = {}, properties = {}, request_options = {})
      return true unless configurations.enabled

      params[:type] = 'track'

      event = Event.create(name, params, properties, request_options)

      event.successful?
    end

  end
end
