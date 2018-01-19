require 'spec_helper'

describe LiveQA::Event do

  describe '.create' do
    let(:response) { double('LiveQA::Request', body:  "{\"object\":\"event\",\"id\":41}") }
    before { expect(LiveQA::Request).to receive(:execute).and_return(response) }

    subject(:create) { LiveQA::Event.create(user_id: 42) }

    it { is_expected.to be_successful }
    it { expect(create.id).to eq(41) }
  end

end
