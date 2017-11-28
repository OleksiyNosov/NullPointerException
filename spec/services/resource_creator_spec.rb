require 'rails_helper'

RSpec.describe ResourceCreator do
  let(:resource_attributes) { attributes_for(:question) }

  let(:resource_class) { Question }

  let(:resource) { instance_double(resource_class, **resource_attributes) }

  subject { ResourceCreator.new resource_class, resource_attributes }

  it { is_expected.to be_an ResourceCrudWorker }

  describe '#process_action' do
    before { allow(resource_class).to receive(:new).with(resource_attributes).and_return resource }

    before { allow(resource).to receive(:save).and_return true }

    its(:process_action) { is_expected.to eq true }
  end

  describe '#call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it { expect { subject.send(:call) }.to_not raise_error }
  end
end
