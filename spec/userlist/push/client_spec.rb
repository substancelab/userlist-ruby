require 'spec_helper'

RSpec.describe Userlist::Push::Client do
  subject { described_class.new(config) }

  let(:config) do
    Userlist::Config.new(push_key: 'test-push-key', push_endpoint: 'https://endpoint.test.local')
  end

  describe '#initialize' do
    context 'when configured with nothing' do
      it 'gets push key from the environment' do
        ENV['USERLIST_PUSH_KEY'] = 'test-push-key'
        instance = described_class.new
        ENV.delete('USERLIST_PUSH_KEY')
        expect(instance.send(:token)).to eq('test-push-key')
      end
    end

    context 'when configured with a Hash' do
      it 'gets push key from the hash' do
        instance = described_class.new(push_key: 'test-push-key')
        expect(instance.send(:token)).to eq('test-push-key')
      end
    end

    context 'when the push_key is missing' do
      let(:config) do
        Userlist::Config.new(push_key: nil, push_endpoint: 'https://endpoint.test.local')
      end

      it 'should raise an error message' do
        expect { subject }.to raise_error(Userlist::ConfigurationError, /push_key/)
      end
    end

    context 'when the push_endpoint is missing' do
      let(:config) do
        Userlist::Config.new(push_key: 'test-push-key', push_endpoint: nil)
      end

      it 'should raise an error message' do
        expect { subject }.to raise_error(Userlist::ConfigurationError, /push_endpoint/)
      end
    end
  end

  describe '#get' do
    it 'should send the request to the given endpoint' do
      stub_request(:get, 'https://endpoint.test.local/events')
        .with(
          headers: {
            'Accept' => 'application/json',
            'Content-Type' => 'application/json; charset=UTF-8',
            'Authorization' => 'Push test-push-key'
          }
        )
        .to_return(status: 202)

      subject.get('/events')
    end
  end

  describe '#post' do
    it 'should send the payload to the given endpoint' do
      payload = { foo: :bar }

      stub_request(:post, 'https://endpoint.test.local/events')
        .with(
          body: JSON.dump(payload),
          headers: {
            'Accept' => 'application/json',
            'Content-Type' => 'application/json; charset=UTF-8',
            'Authorization' => 'Push test-push-key'
          }
        )
        .to_return(status: 202)

      subject.post('/events', payload)
    end
  end

  describe '#put' do
    it 'should send the payload to the given endpoint' do
      payload = { foo: :bar }

      stub_request(:put, 'https://endpoint.test.local/events')
        .with(
          body: JSON.dump(payload),
          headers: {
            'Accept' => 'application/json',
            'Content-Type' => 'application/json; charset=UTF-8',
            'Authorization' => 'Push test-push-key'
          }
        )
        .to_return(status: 202)

      subject.put('/events', payload)
    end
  end

  describe '#delete' do
    it 'should send the request to the given endpoint' do
      stub_request(:delete, 'https://endpoint.test.local/events')
        .with(
          headers: {
            'Accept' => 'application/json',
            'Content-Type' => 'application/json; charset=UTF-8',
            'Authorization' => 'Push test-push-key'
          }
        )
        .to_return(status: 202)

      subject.delete('/events')
    end
  end
end
