require 'rails_helper'

RSpec.describe ResourceDestroyer do
  let(:resource) { build(:question) }

  subject { ResourceDestroyer.new resource }

  it('behaves as resource dispatcher') { is_expected.to be_an ResourceCrudWorker }

  it('publishes resource') { is_expected.to be_kind_of Homie }

  describe '#process_action' do
    before { expect(resource).to receive(:destroy) }

    it('destroys resource') { expect { subject.send :process_action }.to_not raise_error }
  end

  describe '#call' do
    before { expect(subject).to receive(:process_action) }

    before { expect(subject).to receive(:broadcast_resource) }

    it('destroys and broadcast resource') { expect { subject.call }.to_not raise_error }
  end

  describe  '#broadcast_resource' do
    context 'when resource is valid' do
      before { allow(subject).to receive_message_chain(:resource, :valid?).and_return true }

      before { allow(subject).to receive(:serialized_resource).and_return resource }

      before { expect(subject).to receive(:broadcast).with(:succeeded, resource) }

      it('broadcasts serialized resource') { expect { subject.send :broadcast_resource }.to_not raise_error }
    end

    context 'when resource is invalid' do
      let(:resource_errors) { double }

      before { allow(subject).to receive_message_chain(:resource, :valid?).and_return false }

      before { allow(subject).to receive_message_chain(:resource, :errors).and_return resource_errors }

      before { expect(subject).to receive(:broadcast).with(:failed, resource_errors) }

      it('broadcasts resource errors') { expect { subject.send :broadcast_resource }.to_not raise_error }
    end
  end

  describe '#serialized_resource' do
    let(:serialized_resource) { ActiveModelSerializers::SerializableResource.new(resource).as_json }

    before { allow(subject).to receive(:resource).and_return resource }

    it('resturns serialized resource') { expect(subject.send :serialized_resource).to eq serialized_resource }
  end
end
