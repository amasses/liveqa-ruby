require 'spec_helper'

describe LiveQA::Util do

  describe '#compact' do
    it { expect(LiveQA::Util.compact(test: nil, other: 'test')).to eq(other: 'test') }
  end

  describe '#encode_parameters' do
    it { expect(LiveQA::Util.encode_parameters(id: 42, other: 'test')).to eq("id=42&other=test") }
  end

  describe '#underscore' do
    it { expect(LiveQA::Util.underscore('Model')).to eq("model") }
    it { expect(LiveQA::Util.underscore('MyModel')).to eq("my_model") }
  end

end
