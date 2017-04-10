require 'spec_helper'

describe LiveQA::LiveQAObject do

  let(:klass) { Class.new(LiveQA::LiveQAObject) }
  subject(:instance) { klass.new(id: 42, name: 'test', test: true) }

  let(:api_response) { '' }

  describe 'add attribute accessors' do
    it { expect(instance.id).to eq(42) }
    it { expect(instance.name).to eq('test') }
    it { expect(instance.test).to be_truthy }
    it { expect(instance.test?).to be_truthy }
  end

  describe 'add array attribute' do
    it { expect(instance[:id]).to eq(42) }
    it { expect(instance[:name]).to eq('test') }
    it { expect(instance[:test]).to be_truthy }
  end

  describe 'set array attribute' do
    before { instance[:id] = 84 }

    it { expect(instance.id).to eq(84) }
    it { expect(instance[:id]).to eq(84) }
  end

  describe 'method missing' do
    before { instance.card = '42' }

    it { expect(instance.card).to eq('42') }
    it { expect { instance.other }.to raise_error(NameError) }
  end

  describe '#keys' do
    it { expect(instance.keys).to match_array([:id, :name, :test]) }
  end

  describe '#to_hash' do
    it { expect(instance.to_hash).to eq(id: 42, name: 'test', test: true) }
  end

  describe '#to_json' do
    it { expect(instance.to_json).to eq(JSON.generate(id: 42, name: 'test', test: true)) }
  end

  describe '#add_data' do
    before { instance.add_data(:test) }

    it { expect(instance.data).to match_array([:test]) }
  end

  describe '#update_attributes' do
    before { instance.update_attributes(id: 84, other: 'other test') }

    it { expect(instance.id).to eq(84) }
    it { expect(instance.other).to eq('other test') }
    it { expect(instance.name).to eq('test') }
  end

  describe '.initialize_from' do
    context 'with single object' do
      subject(:instance) { klass.initialize_from(api_response) }

      it { is_expected.to be_successful }
    end
  end


end
