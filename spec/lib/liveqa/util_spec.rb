require 'spec_helper'

describe LiveQA::Util do

  describe '#camelize' do
    it { expect(LiveQA::Util.except_keys({ a: 1, b: 2 }, :b)).to eq({ a: 1 }) }
  end

  describe '#camelize' do
    it { expect(LiveQA::Util.camelize('model')).to eq("Model") }
    it { expect(LiveQA::Util.camelize('my_model')).to eq("MyModel") }
  end

  describe '#compact' do
    it { expect(LiveQA::Util.compact(test: nil, other: 'test')).to eq(other: 'test') }
  end

  describe '#deep_compact' do
    let(:payload) {{
      my_key: 'test',
      empty_key: nil,
      another_key: {
        last_key: 42,
        valid_key: 'test',
        empty_key: nil,
        yet_another_key: {
          empty_key: nil
        }
      }
    }}

    let(:expected) {{
      my_key: 'test',
      another_key: {
        last_key: 42,
        valid_key: 'test'
      }
    }}
    it { expect(LiveQA::Util.deep_compact(payload)).to eq(expected) }
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

  describe '#deep_symbolize_key' do
    let(:payload) {{
      'my_key' => 'test',
      'another_key' => {
        'last_key' => 'test',
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

    it { expect(LiveQA::Util.deep_symbolize_key(payload)).to eq(expected) }
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
