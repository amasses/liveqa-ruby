require 'spec_helper'

describe LiveQA::Messages::Base do
  subject(:base) { LiveQA::Messages::Base }

  describe '#to_h' do
    let(:expected_hash) {{
      tracker_id: kind_of(String),
      message_id: kind_of(String),
      timestamp: kind_of(String),
      session_tracker_id: kind_of(String)
    }}

    it { expect(base.to_h).to match(expected_hash) }

    context 'with store' do
      before { LiveQA::Store.set(:tracker_id, 'hello') }

      let(:expected_hash) {{
        tracker_id: 'hello',
        message_id: kind_of(String),
        timestamp: kind_of(String),
        session_tracker_id: 'hello'
      }}

      it { expect(base.to_h).to match(expected_hash) }
    end
  end

end
