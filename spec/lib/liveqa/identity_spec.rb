require 'spec_helper'

describe LiveQA::Identity do

  describe '#update' do
    let(:response) { double('LiveQA::Request', body: "{\"object\":\"identity\",\"id\":1,\"externalId\":\"8b5439f2bc0bc5bc2b80817f29477f0d\",\"trackerIds\":[],\"rawData\":{\"name\":\"Runte, Macejkovic and Reinger\",\"email\":\"hardy@abernathy.com\",\"plan\":\"premium\",\"address\":{\"street\":\"680 Collins Branch\",\"city\":\"Holdenview\",\"state\":\"Alabama\",\"postal_code\":\"51094-2637\",\"country\":\"America\"}},\"devices\":{\"object\":\"list\",\"data\":[{\"object\":\"device\",\"bot\":false,\"botName\":null,\"brand\":null,\"browserName\":\"chrome\",\"fullVersion\":\"62.0.3202.94\",\"known\":true,\"name\":null,\"osFullVersion\":\"10.12.5\",\"osName\":\"mac\",\"osVersion\":\"10\",\"type\":\"desktop\",\"version\":\"62\",\"usedLastAt\":null}]}}") }
    before { expect(LiveQA::Request).to receive(:execute).and_return(response) }

    subject(:update) { LiveQA::Identity.update('8b5439f2bc0bc5bc2b80817f29477f0d', properties: { name: 'Runte, Macejkovic and Reinger' }) }

    it { is_expected.to be_successful }
    it { expect(update.external_id).to eq('8b5439f2bc0bc5bc2b80817f29477f0d') }
  end

end
