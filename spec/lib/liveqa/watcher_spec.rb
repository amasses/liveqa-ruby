require 'spec_helper'

describe LiveQA::Identity do

  describe '#create' do
    let(:response) { double('LiveQA::Request', body: "{\"object\":\"watcher\",\"id\":1}") }
    before { expect(LiveQA::Request).to receive(:execute).and_return(response) }

    subject(:create) { LiveQA::Watcher.create(template_flow: 'My Flow', expected_times: 42) }

    it { is_expected.to be_successful }
    it { expect(create.id).to eq(1) }
  end

end
