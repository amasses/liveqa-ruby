require 'spec_helper'

describe LiveQA::Event do

  describe '.configurations' do
    it { expect(LiveQA.configurations).to be_a(LiveQA::Config) }
  end

  describe '.track' do
    let(:response) { double('LiveQA::Event', successful?: true) }
    after { LiveQA.track('test', { user_id: 42 }, { total: 10 }, { no_ssl: true }) }

    it { expect(LiveQA::Event).to receive(:create).with('test', { user_id: 42, type: 'track' }, { total: 10 }, { no_ssl: true }).and_return(response) }

    context 'not enabled' do
      before { LiveQA.configurations.enabled = false }

      it { expect(LiveQA::Event).to_not receive(:create) }
    end
  end

end
