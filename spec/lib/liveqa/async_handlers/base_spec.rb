require 'spec_helper'

describe LiveQA::AsyncHandlers::Base do
  subject(:base) { LiveQA::AsyncHandlers::Base.new }

  describe '#enqueue' do
    subject(:enqueue) { base.enqueue('Event', 'create', test: true) }

    it { expect { enqueue }.to raise_error(LiveQA::MissingImplementation) }
  end

  describe 'execute' do
    context 'default params' do
      let(:params) { ['LiveQA::Event', 'create', { test: true }] }

      after { base.execute(params) }

      it { expect(LiveQA::Event).to receive(:create).with({ test: true }) }
    end

    context 'more params params' do
      let(:params) { ['LiveQA::Group', 'update', 42, { test: true }, { no_ssl: true }] }

      after { base.execute(params) }

      it { expect(LiveQA::Group).to receive(:update).with(42, { test: true }, { no_ssl: true }) }
    end
  end
end
