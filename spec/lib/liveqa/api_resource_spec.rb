require 'spec_helper'

describe LiveQA::APIResource do

  describe '#request' do
    subject(:resource) { LiveQA::APIResource.request(:post, '/test') }

    context 'valid request' do
      let(:response) { double('response', code: '200', code_type: Net::HTTPOK, body: {}.to_json) }

      context 'default payload' do
        let(:expected_payload) {{
          method:  :post,
          url:     'http://localhost:4003/test',
          payload: '{}',
          use_ssl: false,
          headers: {
            accept:             'application/json',
            content_type:       'application/json',
            x_account_token:    'acc_xx',
            x_space_name:       'LiveQA',
            x_environment_name: 'test'
          }
        }}

        after { resource }

        it { expect(LiveQA::Request).to receive(:execute).with(expected_payload).and_return(response)  }
      end

      context 'with body and post' do
        let(:expected_payload) {{
          method:  :post,
          url:     'http://localhost:4003/test',
          payload: "{\"test\":true}",
          use_ssl: false,
          headers: {
            accept:             'application/json',
            content_type:       'application/json',
            x_account_token:    'acc_xx',
            x_space_name:       'LiveQA',
            x_environment_name: 'test'
          }
        }}

        after { LiveQA::APIResource.request(:post, '/test', { test: true }) }

        it { expect(LiveQA::Request).to receive(:execute).with(expected_payload).and_return(response)  }
      end

      context 'with body and get' do
        let(:expected_payload) {{
          method:  :get,
          url:     'http://localhost:4003/test?test=true',
          payload: "{\"test\":true}",
          use_ssl: false,
          headers: {
            accept:             'application/json',
            content_type:       'application/json',
            x_account_token:    'acc_xx',
            x_space_name:       'LiveQA',
            x_environment_name: 'test'
          }
        }}

        after { LiveQA::APIResource.request(:get, '/test', { test: true }) }

        it { expect(LiveQA::Request).to receive(:execute).with(expected_payload).and_return(response)  }
      end

      context 'with overwrite headers tokens' do
        let(:expected_payload) {{
          method:  :post,
          url:     'http://localhost:4003/test',
          payload: '{}',
          use_ssl: false,
          headers: {
            accept:             'application/json',
            content_type:       'application/json',
            x_account_token:    'acc_42',
            x_space_name:       'MySpace',
            x_environment_name: 'staging'
          }
        }}

        after { LiveQA::APIResource.request(:post, '/test', {}, account_token: 'acc_42', space_name: 'MySpace', environment_name: 'staging') }

        it { expect(LiveQA::Request).to receive(:execute).with(expected_payload).and_return(response)  }
      end
    end

    context 'with errors' do
      before { allow(LiveQA::Request).to receive(:execute).and_raise(LiveQA::RequestError.new(response)) }

      context 'with Net::HTTPUnprocessableEntity' do
        let(:response) { double('response', code: '422', code_type: Net::HTTPUnprocessableEntity, body: {}.to_json, message: 'failed') }

        it { expect { resource }.to_not raise_error }
      end

      context 'with Net::HTTPBadRequest' do
        let(:response) { double('response', code: '400', code_type: Net::HTTPBadRequest, body: {}.to_json, message: 'failed') }

        it { expect { resource }.to raise_error(LiveQA::RequestError) }
      end
    end
  end

end
