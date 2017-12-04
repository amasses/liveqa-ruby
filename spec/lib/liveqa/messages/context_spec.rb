require 'spec_helper'

describe LiveQA::Messages::Context do
  subject(:context) { LiveQA::Messages::Context }

  describe '#to_h' do
    let(:expected_hash) {{
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

    it { expect(context.to_h).to match(expected_hash) }
  end

end
