
require 'spec_helper'

describe LiveQA::Store do

  subject(:store) { LiveQA::Store }

  describe '.store' do
    it { expect(store.store).to eq({})}
  end

  describe '.store' do
    before { store.clear! }
    it { expect(store.store).to eq({})}

    context 'with values' do
      before { store.set(:test, 'value') }
      before { store.clear! }

      it { expect(store.store).to eq({}) }
    end
  end

  describe '.set' do
    before { store.set(:test, 'value') }

    it { expect(store.store).to eq(test: 'value') }
  end

  describe '[]=' do
    before { store[:test] = 'value' }

    it { expect(store.store).to eq(test: 'value') }
  end

  describe '.get' do
    before { store.set(:test, 'value') }

    it { expect(store.get(:test)).to eq('value') }
  end

  describe '[]' do
    before { store[:test] = 'value' }

    it { expect(store[:test]).to eq('value') }
  end

  describe '.exist?' do
    before { store.set(:test, 'value') }

    it { expect(store.exist?(:test)).to be_truthy }
    it { expect(store.exist?(:something)).to be_falsey }
  end

  describe '.exist?' do
    before { store.set(:test, 'value') }
    before { store.delete(:test)}

    it { expect(store.exist?(:test)).to be_falsey }

    context 'value does not exist' do
      it { expect { store.delete(:something) }.to_not raise_error }
    end
  end
end
