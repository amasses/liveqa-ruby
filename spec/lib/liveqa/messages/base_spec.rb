require 'spec_helper'

describe LiveQA::Messages::Base do
  subject(:base) { LiveQA::Messages::Base }

  describe '#to_h' do
    let(:expected_hash) {{
      message_id: kind_of(String),
      timestamp: kind_of(String)
    }}

    it { expect(base.to_h).to match(expected_hash) }
  end

end
