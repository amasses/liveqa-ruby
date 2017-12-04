require 'spec_helper'
require 'liveqa/async_handlers/sidekiq'

describe LiveQA::AsyncHandlers::Sidekiq do
  let(:params) {{}}
  subject(:sidekiq) { LiveQA::AsyncHandlers::Sidekiq.new(params) }

  describe '#initialize' do
    it { expect(sidekiq.options['queue']).to eq('liveqa') }
    it { expect(sidekiq.options['class']).to eq(LiveQA::AsyncHandlers::Sidekiq) }

    context 'with options' do
      let(:params) {{
        queue: 'default'
      }}

      it { expect(sidekiq.options['queue']).to eq('default') }
    end
  end

  describe '#enqueue' do
    after { sidekiq.enqueue('Event', 'create', test: true) }

    let(:expected_params) {{
      'queue' => 'liveqa',
      'class' => LiveQA::AsyncHandlers::Sidekiq,
      'args' => ['Event', 'create', { test: true }]
    }}

    it { expect(::Sidekiq::Client).to receive(:push).with(expected_params) }
  end

  describe 'perform' do
    let(:expected_params) { ['LiveQA::Event', 'create', { test: true }] }

    after { sidekiq.perform(*expected_params) }

    it { expect(sidekiq).to receive(:execute).with(expected_params) }
  end
end
