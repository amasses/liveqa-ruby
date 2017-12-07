require 'liveqa/plugins/sidekiq/client_middleware'
require 'liveqa/plugins/sidekiq/server_middleware'

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add LiveQA::Plugins::Sidekiq::ClientMiddleware
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add LiveQA::Plugins::Sidekiq::ServerMiddleware
  end
end
