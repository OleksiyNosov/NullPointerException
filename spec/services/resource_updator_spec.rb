require 'rails_helper'

RSpec.describe ResourceUpdator do
  let(:resource_attributes) { attributes_for(:question) }

  let(:resource) { instance_double Question }

  subject { ResourceUpdator.new resource, resource_attributes }

  it { is_expected.to be_an ResourceCrudWorker }

  describe '#process_action' do
    before { expect(resource).to receive(:update).with(resource_attributes) }

    it('executes resource update logic') { expect { subject.send :process_action }.to_not raise_error }
  end

  describe '#call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it('executes all methods') { expect { subject.call }.to_not raise_error }
  end
end
