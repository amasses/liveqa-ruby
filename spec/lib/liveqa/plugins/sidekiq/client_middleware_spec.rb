require 'spec_helper'
require 'sidekiq'
require 'liveqa/plugins/sidekiq/client_middleware'

describe LiveQA::Plugins::Sidekiq::ClientMiddleware do

  let(:middleware) { LiveQA::Plugins::Sidekiq::ClientMiddleware.new }

  describe '#call' do
    before { LiveQA::Store.set(:tracker_id, 1) }

    it { expect { middleware.call('MyWorker', {}, 'default', {}) {} }.to_not raise_error }
  end

end
