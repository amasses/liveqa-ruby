require 'spec_helper'

describe LiveQA::Event do

  describe '.configurations' do
    it { expect(LiveQA.configurations).to be_a(LiveQA::Config) }
  end

  describe '.track' do
    let(:response) { double('LiveQA::Event', successful?: true) }
    after { LiveQA.track('test', { user_id: 42, properties: { total: 10 }}, { no_ssl: true }) }

    it { expect(LiveQA::Event).to receive(:create).with({ user_id: 42, properties: { total: 10 }, type: 'track', name: 'test' }, { no_ssl: true }).and_return(response) }

    context 'not enabled' do
      before { LiveQA.configurations.enabled = false }

      it { expect(LiveQA::Event).to_not receive(:create) }
    end
  end

  describe '.identify' do
    let(:response) { double('LiveQA::Event', successful?: true) }
    after { LiveQA.identify(42, { identifier_id: 'xx', properties: { name: 'John Doe' }}, { no_ssl: true }) }

    it { expect(LiveQA::Event).to receive(:create).with({ identifier_id: 'xx', properties: { name: 'John Doe' }, type: 'identify', user_id: 42 }, { no_ssl: true }).and_return(response) }

    context 'not enabled' do
      before { LiveQA.configurations.enabled = false }

      it { expect(LiveQA::Event).to_not receive(:create) }
    end
  end

end
