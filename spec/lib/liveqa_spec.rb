require 'spec_helper'

describe LiveQA::Event do

  describe '.configurations' do
    it { expect(LiveQA.configurations).to be_a(LiveQA::Config) }
  end

  describe '.track' do
    let(:response) { double('LiveQA::Event', successful?: true) }
    after { LiveQA.track('test', { user_id: 42, properties: { total: 10 }}, { no_ssl: true }) }

    let(:expected_arg) {{
      user_id: 42,
      type:    'track',
      name:    'test',
      message_id: kind_of(String),
      timestamp: kind_of(String),
      tracker_id: kind_of(String),
      session_tracker_id: kind_of(String),
      properties: {
        total: 10
      },
      library: {
        name: "liveqa",
        language: "ruby",
        version: kind_of(String)
      },
      server: {
        host: kind_of(String),
        pid: kind_of(Numeric)
      }
    }}

    it { expect(LiveQA::Event).to receive(:create).with(expected_arg, { no_ssl: true }).and_return(response) }

    context 'not enabled' do
      before { LiveQA.configurations.enabled = false }

      it { expect(LiveQA::Event).to_not receive(:create) }
    end
  end

  describe '.identify' do
    let(:response) { double('LiveQA::Event', successful?: true) }
    after { LiveQA.identify(42, { tracker_id: 'xx', properties: { name: 'John Doe' }}, { no_ssl: true }) }

    let(:expected_arg) {{
      tracker_id: 'xx',
      properties: {
        name: 'John Doe'
      },
      type:    'identify',
      user_id: 42,
      message_id: kind_of(String),
      timestamp: kind_of(String),
      session_tracker_id: kind_of(String),
      library: {
        name: "liveqa",
        language: "ruby",
        version: kind_of(String)
      },
      server: {
        host: kind_of(String),
        pid: kind_of(Numeric)
      }
    }}

    it { expect(LiveQA::Event).to receive(:create).with(expected_arg, { no_ssl: true }).and_return(response) }

    context 'not enabled' do
      before { LiveQA.configurations.enabled = false }

      it { expect(LiveQA::Event).to_not receive(:create) }
    end
  end

end
