require 'rails_helper'

RSpec.describe ResourceUpdator do
  let(:resource_attributes) { attributes_for(:question) }

  let(:resource) { instance_double Question }

  subject { ResourceUpdator.new resource, resource_attributes }

  it { is_expected.to be_an ResourceCrudWorker }

  describe '#assemble_resource' do
    before { allow(resource).to receive(:update).with(resource_attributes).and_return resource }

    its(:assemble_resource) { is_expected.to eq resource }
  end

  describe '#call' do
    before { expect(subject).to receive(:assemble_resource) }

    before { expect(subject).to receive(:broadcast_resource) }

    it { expect { subject.call }.to_not raise_error }
  end
end
