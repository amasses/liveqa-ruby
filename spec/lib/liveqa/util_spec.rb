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

  describe '#deep_underscore_key' do
    let(:payload) {{
      'MyKey' => 'test',
      'anotherKey' => {
        'lastKey' => 'test',
        'valid_key' => 'test'
      }
    }}

    let(:expected) {{
      my_key: 'test',
      another_key: {
        last_key: 'test',
        valid_key: 'test'
      }
    }}

    it { expect(LiveQA::Util.deep_underscore_key(payload)).to eq(expected) }
  end

describe '#deep_stringify_key' do
    let(:payload) {{
      my_key: 'test',
      another_key: {
        last_key: 'test',
        valid_key: 'test'
      }
    }}

    let(:expected) {{
      'my_key' => 'test',
      'another_key' => {
        'last_key' => 'test',
        'valid_key' => 'test'
      }
    }}

    it { expect(LiveQA::Util.deep_stringify_key(payload)).to eq(expected) }
  end

  describe '#deep_obfuscate_value' do
    let(:fields) { ['password', 'credit_card'] }
    let(:payload) {{
      password: 'test',
      another_key: {
        credit_card: '41111111',
        valid_key: 'test'
      }
    }}

    let(:expected) {{
      password: '[HIDDEN]',
      another_key: {
        credit_card: '[HIDDEN]',
        valid_key: 'test'
      }
    }}

    it { expect(LiveQA::Util.deep_obfuscate_value(payload, fields)).to eq(expected) }
  end

end
