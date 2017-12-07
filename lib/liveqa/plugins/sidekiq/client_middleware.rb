module LiveQA
  module Plugins
    module Sidekiq
      ##
      # LiveQA \Plugins \Sidekiq \Client \Middleware
      #
      # Client middleware for sidekiq
      #
      class ClientMiddleware

        def call(_worker_class, job, _queue, _redis_pool)
          job['liveqa_store'] = LiveQA::Store.store
          yield
        end

      end
    end
  end
end
