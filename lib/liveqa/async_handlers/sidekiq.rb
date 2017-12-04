require 'sidekiq'

module LiveQA
  module AsyncHandlers
    class Sidekiq < Base
      include ::Sidekiq::Worker

      OPTIONS = {
        'queue' => 'liveqa',
        'class' => self
      }.freeze

      attr_reader :options

      def initialize(options = {})
        @options = OPTIONS.merge(
          Util.deep_stringify_key(options)
        )
      end

      def enqueue(*args)
        ::Sidekiq::Client.push(
          options.merge('args' => args)
        )
      end

      def perform(*args)
        execute(args)
      end

    end
  end
end
