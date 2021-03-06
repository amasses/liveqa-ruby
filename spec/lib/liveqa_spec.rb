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
      },
    }}

    it { expect(LiveQA::Event).to receive(:create).with(hash_including(expected_arg), { no_ssl: true }).and_return(response) }

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
      },
    }}

    it { expect(LiveQA::Event).to receive(:create).with(hash_including(expected_arg), { no_ssl: true }).and_return(response) }

    context 'not enabled' do
      before { LiveQA.configurations.enabled = false }

      it { expect(LiveQA::Event).to_not receive(:create) }
    end
  end

  describe '.set_group' do
    let(:response) { double('LiveQA::Group', successful?: true) }
    after { LiveQA.set_group(42, { properties: { name: 'John Group' }}, { no_ssl: true }) }

    let(:expected_arg) {{
      properties: {
        name: 'John Group'
      },
      message_id: kind_of(String),
      timestamp: kind_of(String),
      session_tracker_id: kind_of(String),
    }}

    it { expect(LiveQA::Group).to receive(:update).with(42, expected_arg, { no_ssl: true }).and_return(response) }

    context 'not enabled' do
      before { LiveQA.configurations.enabled = false }

      it { expect(LiveQA::Group).to_not receive(:update) }
    end
  end

  describe '.set_identity' do
    let(:response) { double('LiveQA::Identity', successful?: true) }
    after { LiveQA.set_identity(42, { properties: { name: 'John Doe' }}, { no_ssl: true }) }

    let(:expected_arg) {{
      properties: {
        name: 'John Doe'
      },
      message_id: kind_of(String),
      timestamp: kind_of(String),
      session_tracker_id: kind_of(String),
    }}

    it { expect(LiveQA::Identity).to receive(:update).with(42, expected_arg, { no_ssl: true }).and_return(response) }

    context 'not enabled' do
      before { LiveQA.configurations.enabled = false }

      it { expect(LiveQA::Identity).to_not receive(:update) }
    end
  end

  describe '.watch' do
    let(:response) { double('LiveQA::Identity', successful?: true) }


    context 'with session' do
      after { LiveQA.watch('My Flow', { expected_times: 42 }, { no_ssl: true }) }

      let(:expected_arg) {{
        template_flow: 'My Flow',
        expected_times: 42,
        message_id: kind_of(String),
        timestamp: kind_of(String),
        session_tracker_id: kind_of(String),
      }}

      it { expect(LiveQA::Watcher).to receive(:create).with(expected_arg, { no_ssl: true }).and_return(response) }
    end

    context 'with session' do
      after { LiveQA.watch('My Flow', { expected_times: 42, without_session: true }, { no_ssl: true }) }

      let(:expected_arg) {{
        template_flow: 'My Flow',
        expected_times: 42,
        message_id: kind_of(String),
        timestamp: kind_of(String),
      }}

      it { expect(LiveQA::Watcher).to receive(:create).with(expected_arg, { no_ssl: true }).and_return(response) }
    end

    context 'not enabled' do
      after { LiveQA.watch('My Flow', { expected_times: 42 }, { no_ssl: true }) }

      before { LiveQA.configurations.enabled = false }

      it { expect(LiveQA::Watcher).to_not receive(:create) }
    end
  end

end
