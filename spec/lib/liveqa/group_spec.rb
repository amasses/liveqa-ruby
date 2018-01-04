require 'spec_helper'

describe LiveQA::Group do

  describe '#update' do
    let(:response) { double('LiveQA::Request', body: "{\"object\":\"group\",\"id\":3,\"externalId\":\"41df8a48a68cb7c94e119ef7f1380537\",\"rawData\":{\"name\":\"Lubowitz, Cartwright and Davis\",\"email\":\"kenya_parker@batz.info\",\"plan\":\"premium\",\"address\":{\"street\":\"19222 Keyshawn Mountain\",\"city\":\"Rogahnmouth\",\"state\":\"Hawaii\",\"postal_code\":\"98441-4908\",\"country\":\"Singapore\"}}}") }
    before { expect(LiveQA::Request).to receive(:execute).and_return(response) }

    subject(:update) { LiveQA::Group.update('41df8a48a68cb7c94e119ef7f1380537', properties: { name: 'Lubowitz, Cartwright and Davis' }) }

    it { is_expected.to be_successful }
    it { expect(update.external_id).to eq('41df8a48a68cb7c94e119ef7f1380537') }
  end

end
