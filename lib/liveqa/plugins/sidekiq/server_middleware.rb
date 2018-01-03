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
          store_worker_data(job)
          LiveQA::Plugins::Rails::MiddlewareData.store_data if defined?(::Rails)
          yield
        ensure
          LiveQA::Store.clear!
        end

        private

        def store_worker_data(job)
          LiveQA::Store.set(
            :worker,
            name: 'sidekiq',
            version: ::Sidekiq::VERSION,
            queue: job['queue'],
            class: job['class'],
            id: job['jid'],
            created_at: convert_to_iso8601(job['created_at']),
            process_at: convert_to_iso8601(job['enqueued_at']),
            args: job['args'],
            retried: job['retry_count'].is_a?(Integer),
            retry_number: job['retry_count'],
            failed_at: convert_to_iso8601(job['failed_at'])
          )
        end

        def convert_to_iso8601(int_time)
          Time.at(int_time).utc.iso8601
        rescue
          nil
        end

      end
    end
  end
end
