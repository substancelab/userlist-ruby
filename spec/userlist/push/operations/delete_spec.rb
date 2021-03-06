require 'spec_helper'

RSpec.describe Userlist::Push::Operations::Delete do
  let(:resource_type) { Userlist::Push::User }
  let(:relation) { Userlist::Push::Relation.new(scope, resource_type, [described_class]) }
  let(:scope) { Userlist::Push.new(push_strategy: strategy) }
  let(:strategy) { instance_double('Userlist::Push::Strategies::Direct') }

  describe '.delete' do
    let(:identifier) { 'identifier' }

    it 'should send the request to the endpoint' do
      expect(strategy).to receive(:call).with(:delete, '/users/identifier')
      relation.delete(identifier)
    end
  end
end
