require 'spec_helper'

describe LiveQA::Event do

  describe '.build_payload' do
    before { LiveQA::Store.set(:tracker_id, '41') }

    let(:expected) {{
      context: {
        library: {
          name: "liveqa",
          language: "ruby",
          version: kind_of(String)
        },
        server: {
          host: kind_of(String),
          pid: kind_of(Numeric)
        }
      },
      message_id: kind_of(String),
      timestamp: kind_of(String),
      tracker_id: '42',
      session_tracker_id: kind_of(String)
    }}

    it { expect(LiveQA::Event.build_payload(tracker_id: '42')).to match(expected) }
  end

  describe '.create' do
    let(:response) { double('LiveQA::Request', body: '') }
    before { expect(LiveQA::Request).to receive(:execute).and_return(response) }

    subject(:create) { LiveQA::Event.create(user_id: 42) }

    it { is_expected.to be_successful }
  end

end
