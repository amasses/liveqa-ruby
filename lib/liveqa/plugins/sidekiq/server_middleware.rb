module LiveQA
  module Plugins
    module Sidekiq
      ##
      # LiveQA \Plugins \Sidekiq \Server \Middleware
      #
      # Server middleware for sidekiq
      #
      class ServerMiddleware

        def call(_worker, job, _queue)
          LiveQA::Store.load_from_hash(job['liveqa_store'])
          yield
        ensure
          LiveQA::Store.clear!
        end

      end
    end
  end
end
