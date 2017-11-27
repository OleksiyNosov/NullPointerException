require 'rails_helper'

RSpec.describe ResourceUpdator do
  let(:resource_attributes) { attributes_for(:question) }

  let(:resource) { instance_double Question }

  subject { ResourceUpdator.new resource, resource_attributes }

  it { is_expected.to be_an ResourceCrudWorker }

  describe '#initialize' do
    before { expect(subject).instance_variable_set(:@resource, resource) }

    before { expect(subject).instance_variable_set(:@params, resource_attributes) }

    it { expect { ResourceUpdator.new resource, resource_attributes }.to_not raise_error }
  end

  describe '#assemble_resource' do
    before { expect(resource).to receive(:update).with(resource_attributes) }

    it { expect { subject.send(:assemble_resource) }.to_not raise_error }
  end

  describe '#call' do
    before { expect(subject).to receive(:assemble_resource) }

    before { expect(subject).to receive(:broadcast_resource) }

    it { expect { subject.call }.to_not raise_error }
  end
end
